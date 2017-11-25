<!--
/*
 * Copyright (c) 2000-2100 Telenet Operaties NV
 * Liersesteenweg 4, 2800 Mechelen, Belgium
 * All Rights Reserved.
 *
 * This software is the confidential and proprietary
 * information of Telenet Operaties NV.
 */
 /****************************************************************************
    Modification Log    :
    Date			Author		Reviewer    Version		Description of change
    -------------------------------------------------------------------------
   25-April-2012	Amandeep	Pavan       0.00a       First draft.
   26-Dec-2012		Charu 		Ankit Jain	1.00		Rel 13.2 CAM CI TFB
   07-June-2016     Roopam      Neha        2.00        Rel 16.3 Increase threshold from max 250 to max 1000
 ****************************************************************************/
-->

<!-- Import all the required classes and change the info corresponding to each screen -->
<%@
	 page language = "java"
         import   = "be.telenet.TeleSessionMgr,
                     be.telenet.utils.GPermission,
                     be.telenet.utils.GTelenetPropertyLoader,
                     be.telenet.afe.installationaddress.BProductTree,
                     be.telenet.BSession,
                     be.telenet.afe.utils.*,
                     be.telenet.afe.product.BSTBDetails,
                     be.telenet.afe.product.BSTBMasterDetails,
                     be.telenet.afe.commonclient.transferobject.order.BSmartcardDetails,
                     be.telenet.afe.pres.crm.constants.GAfeConstants,
                     java.sql.ResultSet,
                     java.util.*,
                     be.telenet.afe.installationaddress.LSmartcard,
                     be.telenet.afe.db.ExternalService,
                     be.telenet.afe.db.ExternalServiceRow,
                     be.telenet.afe.product.BExternalServiceDetails,
                     be.telenet.afe.pres.crm.constants.GAfeDescription"
         session      = "true"
         isThreadSafe = "false"
         contentType="text/html; charset=ISO-8859-1"
%>

<%-- ********************************************************************************************* --%>
<%-- ****************************  Declaration Section Starts ************************************ --%>
<%-- ********************************************************************************************* --%>
<%
    Locale lclCurLcl              = null;		//Used to store the current locale
    BSession objBSession		= null;
    TeleSessionMgr teleSessionMgr = null;
    Vector vctRows = null;

    int iScenarioId = 0; //Stores the scenario To be executed For multiDTV such as ADD/CHANGE/DELETE

    String strScreenNameKey = null;					//Key used to display screen name in header

    String strBoxStatus = null;

    String strPageAction = null;
    String strDigiBoxMACId = null;
	
    //Begin Modify v1.00
    String strSmartcardNumber = null; //SmartCard number needed For Digicard
    //End Modify v1.00
    String strSerialNumber = null;

    String strMDTVIdentifierValue  = null; //Selected Identifier value For multiDTV
    String strSelectedProducts = null;
    String strInstallationAddress= null; // To store installation address
 	String strCheckChildSAPPresent=null;// To store if child SAP is present
 	String strResiOnMulti=null;// To store resi on Multi
 	String strMultiDTVIdentifierValue=null;//To store multiDTV identifier value 
 	
 	Boolean strOrderStatus= false;

    int iPopulateMDTVdetails = 0;//Number of provisioned boxes For the line

    int iMDTVBoxSize = 0; //Number of boxes For multiDTV
    long lBoxProductId = 0;//Store the product id For the type of box.
	//long lSelectedBoxProductId = 0;
    Boolean bConfirmModifyFlag = null;
    Boolean bConfirmHerpairFlag = null;
    Boolean bConfirmRemoveFlag = null;
    Boolean bConfirmStartFlag = null;
    Boolean bConfirmPairFlag = null;
    // To store if child SAP is present
 
    ArrayList arlPopulateMDTVdetails = null; //ArrayList arlPopulateTSDTVdetails = null;
    ArrayList alstMDTVProducts = null; //ArrayList alstTSDTVProducts = null;
    ArrayList arlMutliDTVIdentifiers= null;// To store all the array list multiDTV identifiers for the customer

    BSmartcardDetails objSmartCardDetails = null;
    BExternalServiceDetails objBExternalServiceDetails = null; //Contains the details of all the boxes To be populated In the session
    BExternalServiceDetails objSelectedExternalService = null; //Contains the details of box To be provisioned. Needed To store the details of the unprovsioned box In the session

    ExternalServiceRow esRow = null; // This will contain detail of Each row of the packs/products To be displayed On screen.
%>
<%-- ********************************************************************************************* --%>
<%-- ****************************  Declaration Section Ends ************************************   --%>
<%-- ********************************************************************************************* --%>


<%-- ********************************************************************************************* --%>
<%-- ****************************  Initialization Section Starts ********************************* --%>
<%-- ********************************************************************************************* --%>
<%
       strScreenNameKey = "AFEMULTIDTV01"; 		//Key used to display HTML title.

       String strAfeJspPath     = GTelenetPropertyLoader.strGetProperty(GAfeConstants.AfeJSPPath);
       String strAfeServletPath = GTelenetPropertyLoader.strGetProperty(GAfeConstants.AfeServletPath);

       String strImagePath      = strAfeJspPath + GAfeFilePaths.strImagesPath; 
       String strServletPath    = strAfeServletPath + GAfeFilePaths.strMultiDTVServlet; // Path For controller For fetching the values
       String strCSSPath        = strAfeJspPath + GAfeFilePaths.strCSSPath;		//used for storing CSS path.

       //Check If the session is new.
       if(session.isNew())
       {
           response.sendRedirect(strAfeJspPath + GAfePropertyLoader.strGetProperty(GAfeConstants.LOGINJSP));
           return;
       }

       teleSessionMgr = (TeleSessionMgr)session.getValue(Constants.SESSION_DATA_CONTAINER);

       if(null != teleSessionMgr)
       {
           // getting the values of locale
           lclCurLcl   = (Locale) teleSessionMgr.getValue(GAfeConstants.lclCurLcl);

           //Fetching of BSession.
           if(null != teleSessionMgr.getValue(Constants.KEY_BSession_obj))
           {
               objBSession = (BSession) teleSessionMgr.getValue(Constants.KEY_BSession_obj);
           }

           if(objBSession != null)
           {
               lclCurLcl = objBSession.lclCurLcl;
           }
           strPageAction = (String)teleSessionMgr.getValue(GAfeConstants.KEY_hdnPageAction);
           strOrderStatus= (Boolean)teleSessionMgr.getValue(GAfeConstants.ORDER_COMPLETED);
       }
       if(null == lclCurLcl)
       {
           lclCurLcl = Locale.getDefault();
       }

	   //Set the default Locale
       GResourceBundle.setLocale(lclCurLcl);

//Fetches the MultiDTV boxes from session.
alstMDTVProducts = (ArrayList)teleSessionMgr.getValue(GAfeConstants.LIST_MDTV_BOXES);

//Assign the number type of boxes of multiDTV To a varaiable
if(null != alstMDTVProducts && 0 < alstMDTVProducts.size())
	{
	iMDTVBoxSize = alstMDTVProducts.size();
	}


//Fetches the MultiDTV Box details after order is executed/Provisioned Boxes For that line. 
//Size zero check Not done because when the screen Is first loaded it will Not have provisioned boxes.
arlPopulateMDTVdetails = (ArrayList)teleSessionMgr.getValue(GAfeConstants.ARRLST_TSDTV_PRODUCTS);
if(arlPopulateMDTVdetails != null)
	{
	iPopulateMDTVdetails = arlPopulateMDTVdetails.size();
	}

//Fetches the Line Idenitifer Value.
strMDTVIdentifierValue = (String)teleSessionMgr.getValue(GAfeConstants.KEY_SelectedMDTVLineIdentifierValue);

//System.out.println("Value of strPageAction :: "+strPageAction);

//Fetches the MultiDTV products/packs from the Application cache depending upo n the product package id.
ExternalService esTable = (ExternalService) teleSessionMgr.getMasterTable(GMasterDataConstants.EXTERNALSERVICE_TB);
vctRows = esTable.getVctExternalServ(GAfeDescription.MULTIDTV_PACKAGE_PRODUCTID);

//product id For the type of box.
 if(null != teleSessionMgr.getValue(GAfeConstants.lBoxProductId))
       {
           lBoxProductId = ((Long)teleSessionMgr.getValue(GAfeConstants.lBoxProductId)).longValue();
       }

//The key stores the values of the box In Case it Not blacklisted/unusable.(Condition checked And populated In controller)
if(null != teleSessionMgr.getValue(GAfeConstants.KEY_BOX_STATUS))
       {
          strBoxStatus = teleSessionMgr.getValue(GAfeConstants.KEY_BOX_STATUS).toString();
       }

//Stores the digibox id For box
if (null != teleSessionMgr.getValue(GAfeConstants.str_DigiBoxMacId))
       {
          strDigiBoxMACId = teleSessionMgr.getValue(GAfeConstants.str_DigiBoxMacId).toString();
       }

//Store the value from the KEY(populated In controller).True(box successfully paired) Or Null(pairing Not done)
if(null != teleSessionMgr.getValue(GAfeConstants.KEY_bConfirmPairFlag))
       {
          bConfirmPairFlag = (Boolean) teleSessionMgr.getValue(GAfeConstants.KEY_bConfirmPairFlag);
       }

//Stores all the provisioned boxes details For MultiDTV.Order status can be In NEW/INPROGRESS
if( null != teleSessionMgr.getValue(GAfeConstants.KEY_TSDTV_SmartcardDetails))
       {
           objSmartCardDetails = (BSmartcardDetails)teleSessionMgr.getValue(GAfeConstants.KEY_TSDTV_SmartcardDetails);
           if( null != objSmartCardDetails)
           {
               iScenarioId = objSmartCardDetails.getiScenarioId();
           }
       }

//Stores the values of To be provisoned boxes(before the order Is created)
if( null != teleSessionMgr.getValue(GAfeConstants.KEY_objBExternalServiceDetails))
       {
           objSelectedExternalService = (BExternalServiceDetails)teleSessionMgr.getValue(GAfeConstants.KEY_objBExternalServiceDetails);
           if( null != objSelectedExternalService)
           {
               
               strSerialNumber = objSelectedExternalService.getSTBSerialNumber();
               strSelectedProducts = objSelectedExternalService.getSelectedProducts();
               //Begin Add v1.00
               strSmartcardNumber = objSelectedExternalService.getSmartCardNumber();
               //End Add v1.00
           }
       }
//Contains list of all the identifiers to be shown in the dropdown
arlMutliDTVIdentifiers=(ArrayList)teleSessionMgr.getValue(GAfeConstants.arrlstMultiDTVIdentifiers);

//String containing Child SAP present status
strCheckChildSAPPresent =(String)teleSessionMgr.getValue(GAfeConstants.CHILD_SAP_PRESENT);

//String containing res on Multi status
strResiOnMulti = (String)teleSessionMgr.getValue(GAfeConstants.RES_ON_MULTI);

//String containing address 
strInstallationAddress = (String)teleSessionMgr.getValue(GAfeConstants.STR_INSTALLATION_ADDRESS);

arlPopulateMDTVdetails = (ArrayList)teleSessionMgr.getValue(GAfeConstants.ARRLST_MDTV_PRODUCTS);

String strSelectedMultiDTVIdentifierValue= (String)teleSessionMgr.getValue(GAfeConstants.KEY_SelectedMDTVLineIdentifierValue);

BSTBMasterDetails objBSTBMasterDetails= new BSTBMasterDetails();

    boolean bPermCpProd = false;
    boolean bPermMdfyProd = false;
    boolean bPermHerProd = false;
    boolean bPermRemProd = false;
    boolean bPermStart = false;
    boolean bPermRefresh = false;
    boolean bPermTerug = false;

//Checks permission For the different button
    if(GPermission.bCheckPermission(strScreenNameKey,"btCopy",objBSession))
    {
         bPermCpProd = true;
    }

    if(GPermission.bCheckPermission(strScreenNameKey,"btModify",objBSession))
    {
         bPermMdfyProd = true;
    }

    if(GPermission.bCheckPermission(strScreenNameKey,"btHerpair",objBSession))
    {
         bPermHerProd = true;
    }

    if(GPermission.bCheckPermission(strScreenNameKey,"btRemove",objBSession))
    {
         bPermRemProd = true;
    }

    if(GPermission.bCheckPermission(strScreenNameKey,"btStart",objBSession))
    {
         bPermStart = true;
    }

    if(GPermission.bCheckPermission(strScreenNameKey,"btRefresh",objBSession))
    {
         bPermRefresh = true;
    }

    if(GPermission.bCheckPermission(strScreenNameKey,"btTerug",objBSession))
    {
         bPermTerug = true;
    }
%>
<%-- ********************************************************************************************* --%>
<%-- ****************************  Initialization Section Ends *********************************   --%>
<%-- ********************************************************************************************* --%>

<%-- ********************************************************************************************* --%>
<%-- ****************************  HTML Section Starts ******************************************* --%>
<%-- ********************************************************************************************* --%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">

<%@page import="org.richfaces.iterator.ForEachIterator"%><HTML>
<HEAD>

<TITLE><%=GResourceBundle.getText(strScreenNameKey)%></TITLE>
        <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=ISO-8859-1">
        <META HTTP-EQUIV="expires" content="now, 0"			       >
        <META HTTP-EQUIV="Pragma" CONTENT="No-cache"			       >
        <META HTTP-EQUIV="cache-control" content="no-store, no-cache, max-age=0, must-revalidate" >
        <META HTTP-EQUIV="Content-Script-Type" CONTENT="text/javascript">
</HEAD>
<link rel="stylesheet" href="<%=strCSSPath%>" type="text/css">
	<body class=MainBody valign="top" align="left" border="2"
	      leftmargin="0" topmargin="0" marginwidth="0" marginheight="0"
	      cellpadding="0" cellspacing="0" onload="fnLoad()">


    <FORM name="foProdDetailMDTV" method="POST" action="<%=strServletPath%>" >
    

	
		<TABLE width="100%" height="5%" border=0 cellspacing=0 cellpadding=0>
		<TR valign=top height="10%">
			<TD><%@ include file="/be/telenet/afe/CustomerHeader.txt" %><!-- including header jsp --></TD>
		</TR>
		</TABLE>
	
    
    <INPUT type="hidden" name="hdnMDTVAction" value="" >

<TABLE width="100%" height="5%" border=0 cellspacing=0 cellpadding=0>
<TR><TD>&nbsp;&nbsp;
	<SELECT onchange="fnRefresh()" id="selectedmultidtv" name="selectedmultidtv" class="BoxComboBox">
				 <%
				 
				 for (Iterator iterator =  arlMutliDTVIdentifiers.iterator(); iterator.hasNext();){
					 strMultiDTVIdentifierValue=(String)iterator.next();
					 
					 if(strMultiDTVIdentifierValue.equals(strSelectedMultiDTVIdentifierValue)){
					 %>
				<option value="<%=   
						   strMultiDTVIdentifierValue%>" selected="selected"><%=strMultiDTVIdentifierValue %>
				<%} else{%>
				<option value="<%=   
						   strMultiDTVIdentifierValue%>"><%=strMultiDTVIdentifierValue %>
						   
						   <%}} %>
	</SELECT>
	</TD></TR>
</TABLE>
<br>

<table width="100%" height="25%">
	<tr>
		<td valign="top" align="left">
			&nbsp;&nbsp;<LABEL class="GenLabel1" > <%=GResourceBundle.getText("lblMDtvIdentifierValue")%></LABEL>
		</td>						  
		<td valign="top" align="left">
				<table width="90%" border=1 bordercolor="black" CELLSPACING=0 cellpadding="2">	
				<tr>	   
					<td colspan="2" class="GenLabel" > <!-- Value of DTV Identifier -->
						<%=strSelectedMultiDTVIdentifierValue%>
						
						</td>
						
				</tr>
				<tr>		
					<td>
						<LABEL class="GenLabel"> <%=GResourceBundle.getText("lblResOnMultiValue")%></LABEL>
					</td>
					<td class="GenLabel">
					<!--Value Yes/No to be shown dependent of Coax products from value populated in the session -->
						<%=strResiOnMulti%>
						
					</td>
				</tr>
				<tr>
					<td>
						<LABEL class="GenLabel"> <%=GResourceBundle.getText("lblChildOnSAPPresent")%> 
						</LABEL>
					</td>
					<td class="GenLabel">	
						
						<%=strCheckChildSAPPresent %>
					</td>
				</tr>
				<tr>
					<td>
						<LABEL class="GenLabel"> <%=GResourceBundle.getText("lblInstallationAddress")%>
						</LABEL>
					</td>
					<td class="GenLabel">
						<!-- Value of Address to be shown -->
						<%=strInstallationAddress %>
					</td>
				</tr>
				
			</table>
		</td>
		<td valign="top" align="left">
			<SELECT name="productList" class="MultiBox" MULTIPLE onclick="fnEnableCopy()">
			 <%  int iSize=0;
			 iSize= vctRows.size();
			 for(int i=0; i < iSize; i++)
                                {
                                    esRow = (ExternalServiceRow)vctRows.get(i);
                                    if (null != esRow)
                                    {%>
									<!-- Different packs to be shown -->
                                        <option value=<%= esRow.getlIndexId()%>><%=esRow.getlIndexId()%>-<%=esRow.getStrDescription()%></option>
                                  <%}
                                }%>
           </SELECT>
		</td>
		<td>
			<p>
			&nbsp;
				<input type="button" class="MediumButton" value="<%=GResourceBundle.getText("btCopy")%>" name="btCopy" onclick="fnCopyProd()" 
				<%if(!bPermCpProd) {%>
				disabled
				<%}%>
				>
				
			</p>
		</td>
	</tr>
</table>
<br>

<BR>
        <DIV class="ScrollingWidth">
           <TABLE width="100%" height="50%">
                <TR valign="top">
                    <TD>
<TABLE class=ResultTable id="addbox" border="1" cellspacing="0" cellpadding="0" width="98%" align="center" >
	 <tr class=HeaderResultTable>
		  <td align="center">
			<%=GResourceBundle.getText("lblSelect")%>
		  </td>
		  <td align="center">
			<%=GResourceBundle.getText("lblType")%>
		  </td>
		 <!-- Begin Add v1.00 -->
		  <td align="center">
			<%=GResourceBundle.getText("lblSmartSN")%>
		  </td>
		 <!-- End Add v1.00 -->
		  <td align="center">
			<%=GResourceBundle.getText("lblSTBCA")%>
		  </td>
		  <td align="center">
			<%=GResourceBundle.getText("lblSTBMAC")%>
		  </td>
		  <td align="center">
			<%=GResourceBundle.getText("lblProducts")%></td>
		  <td align="center">
			<%=GResourceBundle.getText("lblStatus")%></td>
		  <td align="center">
			<%=GResourceBundle.getText("lblOrders")%></td>
		  <td align="center">
			<%=GResourceBundle.getText("lblActivDate")%></td>
		  <td align="center">
			<%=GResourceBundle.getText("lblModDate")%></td>
	 </tr>

<% 
	//Get the size of the arraylist containing all the MultiDTV details
	if(arlPopulateMDTVdetails!=null){
	iPopulateMDTVdetails = arlPopulateMDTVdetails.size();
	
	for(int i = 0 ; i < iPopulateMDTVdetails; i++)
	{
	objBExternalServiceDetails = (BExternalServiceDetails)arlPopulateMDTVdetails.get(i);         
    //If details are present                   
    if(null != objBExternalServiceDetails)
	//Create a radio button
%>
	<tr id="row<%=i+1%>">

		<!-- Radio buttons to be displayed for selection -->
		<td align="center">
			<input type="radio" value="V1"  name="rdButton" onclick="fnColorRow();fnSelectProd(document.getElementById('row<%=i+1%>'),<%=i%>);fnDisableTextBoxes()">
		</td>

		<!-- Display the type of box-->
		<td align="center" class="GenLabelSmall"><%if(objBExternalServiceDetails.getBoxType()==null || objBExternalServiceDetails.getBoxType()==""){%>&nbsp;<%}else{%><%=objBExternalServiceDetails.getBoxType()%><%}%></td>

		<!-- Begin Add v1.00 -->
		<!-- Display the Smartcard number, for non digicard boxes show "-" -->
		<td align="center" class="GenLabelSmall"><%if(objBExternalServiceDetails.getSmartCardNumber().equalsIgnoreCase(GAfeConstants.STRING_ZERO)){%>-<%}else{%><%=objBExternalServiceDetails.getSmartCardNumber()%><%}%></td>
		<!-- End Add v1.00 -->

		<!-- Display the STB number-->
		<td align="center" class="GenLabelSmall"><%if(objBExternalServiceDetails.getSTBSerialNumber()==null || objBExternalServiceDetails.getSTBSerialNumber()==""){%>&nbsp;<%}else{%><%=objBExternalServiceDetails.getSTBSerialNumber()%><%}%></td>

		<!--Display the STBMac address -->
		<td align="center" class="GenLabelSmall"><%if(objBExternalServiceDetails.getSTBMacAddress()==null || objBExternalServiceDetails.getSTBMacAddress()==""){%>&nbsp;<%}else{ %><%=objBExternalServiceDetails.getSTBMacAddress()%><%}%></td>
		
		<!--Display the products-->
		<td align="center" class="GenLabelSmall"><%if(objBExternalServiceDetails.getOrderStatus()==null || objBExternalServiceDetails.getOrderStatus()==""){ %>&nbsp;<%}else{%><%=objBExternalServiceDetails.getSelectedProducts()%><%}%></td>

		<!--Display the order status-->
		<td align="center" class="GenLabelSmall">
		<%if(objBExternalServiceDetails.getOrderStatus()==null || objBExternalServiceDetails.getOrderStatus()==""){%>&nbsp;<%}else{%><%=objBExternalServiceDetails.getOrderStatus()%><%}%></td>

		<!--Display the order type-->
		<td align="center" class="GenLabelSmall">
		<%if(objBExternalServiceDetails.getOrderType()==null || objBExternalServiceDetails.getOrderType()==""){ %>&nbsp;<%}else{%><%=objBExternalServiceDetails.getOrderType()%><%}%></td>

		<!--Display the order activation date-->
		<td align="center" class="GenLabelSmall">
		<%if(objBExternalServiceDetails.getActivationDate()==null || objBExternalServiceDetails.getActivationDate()==""){ %>&nbsp;<%}else{%><%=objBExternalServiceDetails.getActivationDate()%><%}%></td>
		

		<!--Display the order modification date-->
		<td align="center" class="GenLabelSmall">
		<%if(objBExternalServiceDetails.getModificationDate()==null || objBExternalServiceDetails.getModificationDate()==""){ %>&nbsp;<%}else{ %><%=objBExternalServiceDetails.getModificationDate()%><%} %></td>

	</tr>
	<%
	//Close the Loop after all the provisioned boxes are shown.
	}
	}
	%>
    <% // For CR 5303 Increase threshold from max 250 to max 1000
    if(iPopulateMDTVdetails<1000)
	{
	%>
	<tr id="row<%=iPopulateMDTVdetails+1%>"> 
		<!-- radio button for an unprovisioned box-->
		<td align="center">
	    <input type="radio" value="1" name="rdButton" checked onclick="fnColorRow();fnEnableStart(document.getElementById('row<%=iPopulateMDTVdetails+1%>'))">
        </td>                           
		<!-- List the boxes to be displayed for multiDTV-->
		<td>
			<SELECT name="cmbBoxType" class="BoxComboBox" onchange="fnEnableStart(document.getElementById('row<%=iPopulateMDTVdetails+1%>'))">
             
			<%//Get the details of the boxes available For multi DTV
			for(int i = 0 ; i < iMDTVBoxSize ; i++)
			{
				 objBSTBMasterDetails =(BSTBMasterDetails)alstMDTVProducts.get(i);
	                                                if( null != objBSTBMasterDetails)
	                                                	
			%>
			<OPTION VALUE=<%=objBSTBMasterDetails.getlProductID()%> <%if(lBoxProductId == objBSTBMasterDetails.getlProductID()) {%> SELECTED <%}%>><%=objBSTBMasterDetails.getstrDescription()%></OPTION>
            <%} %>
            </SELECT>
		</td>

		<%
		//Get STBSerial Number, Selected products value  from session
			if( null != teleSessionMgr.getValue(GAfeConstants.KEY_objBExternalServiceDetails))
       {
           objSelectedExternalService = (BExternalServiceDetails)teleSessionMgr.getValue(GAfeConstants.KEY_objBExternalServiceDetails);
           if( null != objSelectedExternalService)
           {
               strSerialNumber = objSelectedExternalService.getSTBSerialNumber();
               strSelectedProducts = objSelectedExternalService.getSelectedProducts();
               //Begin Add v1.00
               strSmartcardNumber = objSelectedExternalService.getSmartCardNumber();
               //End Add v1.00
           }
       }
		%>
		
		<!-- Begin Add v1.00 -->
		<!-- Display the smartcard serial number -->
		<td>
			<INPUT type="text" align="center" NOWRAP maxlength="12" class="SmallTextBoxFT" name="txtSmartSN" disabled
			<% 
			if( null != strSmartcardNumber)
			{%>
			value="<%=strSmartcardNumber%>"
			<%}%>
			onkeyup="fnEnableStart(document.getElementById('row<%=iPopulateMDTVdetails+1%>'))">
		</td>
		<!-- End Add v1.00 -->

		<!-- Display the STB serial number-->
		<td>
			<INPUT type="text" align="center" NOWRAP maxlength="12" class="SmallTextBoxFT" name="txtSTBCA" 
			<% 
			if( null != strSerialNumber)
			{%>
			value="<%=strSerialNumber%>"
			<%}%> 
			onkeyup="fnEnableStart(document.getElementById('row<%=iPopulateMDTVdetails+1%>'))">
		</td>

		<%
		//Get STB Mac from session in case of STB number is present/pairing done
		if (null != teleSessionMgr.getValue(GAfeConstants.str_DigiBoxMacId)){
        strDigiBoxMACId = teleSessionMgr.getValue(GAfeConstants.str_DigiBoxMacId).toString();
        }
		%>

		<!-- Display the digibox MAC id, it does not have to be editable-->
		<td>
		<INPUT type="text" maxlength="18" name="txtSTBMAC" class="SmallTextBoxFT" disabled 
		<% if( null != strDigiBoxMACId){%>
		value="<%=strDigiBoxMACId%>"
		<%}%> 
		>	
		</td>

		<!-- Display the packs for the box-->
		<td>
		<INPUT type="text" name="txtProducts" class="SmallTextBoxFT" readonly  
		<% if( null != strSelectedProducts){%>
		value="<%=strSelectedProducts%>"
		<%}%> 
		>
		</td>

		<!-- Display empty labels for order status, order type and dates, since they dont have to be shown for unprovisoned box-->
		
		<td align="center" class="GenLabelSmall">NEW</td>

		<td class="GenLabelSmall">
		&nbsp;
		</td>

        <td class="GenLabelSmall">
		&nbsp;
		</td>

        <td class="GenLabelSmall">
		&nbsp;
		</td>
	
	</tr>
	<%
	}
	%>
</TABLE>
</TD>
</TR>
</TABLE>
</DIV>


<BR>
<table valign="center" cellpadding="0" cellspacing="0" border="0" width="100%" align=left class=MiniHeaderTable height="10%">
             <tr>
                <TD class=MiniHeaderTable>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					
					<!--Display Wijzig Product button-->
					<INPUT type=button class = Mediumbutton value="<%=GResourceBundle.getText("mod01")%>" name="btModify" onclick="fnModify_Product()"  
					<%if(!bPermMdfyProd) {%>
					disabled
					<%}%>
					>&nbsp;&nbsp;&nbsp;&nbsp;
					<!--Display verwijder/delete box button-->
					<INPUT type=button class = Mediumbutton value="<%=GResourceBundle.getText("remove")%>" name="btRemove" onclick="fnRemove()" 
					<%if(!bPermRemProd) {%>
					disabled
					<%}%>
					&nbsp;&nbsp;&nbsp;&nbsp;
					>

					<!--Display Herpair button-->
					<INPUT type=button class = Mediumbutton value="<%=GResourceBundle.getText("Herpair")%>" name="btHerpair" onclick="fnHerpair()" 
					<%if(!bPermHerProd) {%>
					disabled
					<%}%>
					>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

					<!--Display Start button-->
					<INPUT type=button class = Mediumbutton value="<%=GResourceBundle.getText("start")%>" name="btStart" onclick="fnSubmit('Start')" 
					<%if(!bPermStart) {%>
					disabled
					<%}%>
					>
					 
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

					<!--Display refresh button-->
					<INPUT type=button class = Mediumbutton value="<%=GResourceBundle.getText("refresh")%>" name="btRefresh" onclick="fnRefresh()" 
					<%if(!bPermRefresh) {%>
					disabled
					<%}%>
					>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

					
					<INPUT type=button class = Mediumbutton value="<%=GResourceBundle.getText("terug1")%>" name="btTerug" onclick="fnTerug()" 
					<%if(!bPermTerug) 
					{%>disabled
					<%}%>
					>
					&nbsp;

                </TD>

             </tr>
</table>
	<INPUT type="hidden" name = "hdnMultiDTVIdentifierValue" value="<%=strSelectedMultiDTVIdentifierValue%>" >
	<INPUT TYPE="hidden" NAME = "hdnPageAction" value="<%=strPageAction%>">
    <INPUT TYPE="hidden" name = "hdnMDTVScenario" value="<%=iScenarioId%>">
    <INPUT TYPE="hidden" name = "hdnMDTVOrderStatus" value="<%=strOrderStatus%>">
    <INPUT TYPE="hidden" NAME = "hdnActualScenario" value="">
    <INPUT TYPE="hidden" NAME = "hdnIndexIdSelectedRow" value="">
    <INPUT TYPE="hidden" NAME = "hdnNewMacId" value="">
    <INPUT TYPE="hidden" NAME = "hdnActivationUser" value="">
    <INPUT TYPE="hidden" NAME = "hdnRadioBtnNRC" value="">
    <INPUT TYPE="hidden" NAME = "hdnSelectedProd" value="">
  <!--   <INPUT TYPE="hidden" NAME = "hdnSelectedBox" value=""> -->
    </TABLE>
</FORM>
</BODY>

  	
  	
</HTML>
<%-- ****************************  JavaScript Section Starts ************************************* --%>
<SCRIPT LANGUAGE="JavaScript">
<%@ include file="/be/telenet/Commonfunctions.txt"%>
function fnSelectProd(selectProd,i){

	//Initially disable all the buttons except Herlaad/Refresh
	document.foProdDetailMDTV.productList.disabled = true;
	document.foProdDetailMDTV.btStart.disabled = true;
	document.foProdDetailMDTV.btModify.disabled = true;
	document.foProdDetailMDTV.btRemove.disabled = true;
	document.foProdDetailMDTV.btHerpair.disabled = true;
	document.foProdDetailMDTV.btCopy.disabled = true;
	


	//For the selected row get the packs (in case of provisioned)and the order status
	var vSelectProduct = selectProd.getElementsByTagName('TD');
	//Begin Modify v1.00
    var vSelectedPacks = vSelectProduct[5].innerHTML;
  
    var orderStatus = vSelectProduct[6].innerHTML;	
    var orderType = vSelectProduct[7].innerHTML;
    //End Modify v1.00
    var j = 0;

    var vProductListLength = 
        document.foProdDetailMDTV.productList.options.length;
 
 
	//document.foProdDetailMDTV.hdnSelectedBox.value =vSelectProduct[1].innerHTML;
 

    //Disable the productlist
    for(j = 0; j < vProductListLength ; j++){
		document.foProdDetailMDTV.productList.options[j].selected=false;
	}
	
    // To be used when Wijzig Product is clicked and in the controller
    document.foProdDetailMDTV.hdnIndexIdSelectedRow.value = i;

    /*In case the order is completed then enable Change Product, Remove 
    and Herpair buttons and also populate the value of selected packs*/
    if(orderStatus == 'COMPLETED')
    {
        
          document.foProdDetailMDTV.productList.disabled = true;
          document.foProdDetailMDTV.btStart.disabled = true;
          <%if(bPermMdfyProd)
          { %>
            document.foProdDetailMDTV.btModify.disabled = false;
         <% }
          if(bPermRemProd)
          { %>
            document.foProdDetailMDTV.btRemove.disabled = false;
         <% }
          if(bPermHerProd)
          { %>
            document.foProdDetailMDTV.btHerpair.disabled = false;
          <%} %>
         
	fnSelectPackList(vProductListLength,vSelectedPacks);
    }

    /*In case of an unprovisioned box enable the product list, 
    modify ,remove and herpair button  */      
    else if( orderType == 'NEW')
    {
    	if (orderType != ' ' && orderType != '&nbsp;') {
    		document.foProdDetailMDTV.productList.disabled = true;
    	} else {
    		document.foProdDetailMDTV.productList.disabled = false;    		
    	}
      document.foProdDetailMDTV.btModify.disabled = true;         
      document.foProdDetailMDTV.btRemove.disabled = true; 
      document.foProdDetailMDTV.btHerpair.disabled = true;
    }


}
//=================================================================
//Function Name: fnEnableCopy()
//Description	: Enables 'Copy Products' button if any product is 
//					selected
//Called When  : Product List is clicked
//Input Param	: None
//Output Param	: None
//================================================================
function fnEnableCopy()
{
	//Add Rel 14.1 DSO
	<%-- var vBoxSelected = document.foProdDetailMDTV.cmbBoxType.value;
	//alert (vBoxSelected+'vBoxSelected');
	var productListLength = 0;
	var iCount = 0;
	bDTAPackSelected = false;
	bNonDTAPackSelected = false;
	productListLength = document.foProdDetailMDTV.productList.options.length;
	//alert(document.foProdDetailMDTV.hdnSelectedBox.value + 'document.foProdDetailMDTV.hdnSelectedBox.value');
	//alert(document.foProdDetailMDTV.hdnActualScenario.value+'document.foProdDetailMDTV.hdnActualScenario.value');
	if((document.foProdDetailMDTV.hdnSelectedBox.value != "") && (document.foProdDetailMDTV.hdnActualScenario.value == "WijzigProduct")){
		if(document.foProdDetailMDTV.hdnSelectedBox.value == "<%=GAfeDescription.DTA%>" ){
		  vBoxSelected = <%=GAfeConstants.MDTV_DTA_BOX%> ;
		}
		else{
			vBoxSelected = 0;
		}
	}
	
	
	
	for(iCount=0; iCount<productListLength; iCount++)
	 {	        
  		if((document.foProdDetailMDTV.productList.options[iCount].selected==true) 
  			&&(document.foProdDetailMDTV.productList.options[iCount].value==<%=GAfeConstants.MULTIDTV_DTA_PACKAGE%>) && !bDTAPackSelected)
		    { 
                bDTAPackSelected = true;
	        }
        else if((document.foProdDetailMDTV.productList.options[iCount].selected==true) 
        	&&(document.foProdDetailMDTV.productList.options[iCount].value!=<%=GAfeConstants.MULTIDTV_DTA_PACKAGE%>) && !bNonDTAPackSelected)
        	{
                bNonDTAPackSelected = true;
			}
	 }	
	 
	 if(((vBoxSelected == <%=GAfeConstants.MDTV_DTA_BOX%> && bDTAPackSelected==true && bNonDTAPackSelected==false)
	 	||(vBoxSelected != <%=GAfeConstants.MDTV_DTA_BOX%> && bDTAPackSelected==false && bNonDTAPackSelected==true))&& <%=bPermCpProd%>)
	 		{
	 		document.foProdDetailMDTV.btCopy.disabled = false;
	 		}
	 		else{
	 		
	 		document.foProdDetailMDTV.btCopy.disabled = true;
	 		}
	//Add End Rel 14.1 DSO --%>
	
	//Delete Rel 14.1 DSO
  <%if(bPermCpProd)
    {  %>
     document.foProdDetailMDTV.btCopy.disabled = false;
    <% }   %>    
    //Delete End Rel 14.1 DSO
}
//===============================================================
//Function Name: fnLoad()
//Description	: Called whenever the screen is loaded
//Called When  : Called on load of the page.
//Input Param	: None
//Output Param	: None
//================================================================
function fnLoad(){


	//To disable  all buttons except Refresh button on first load
	document.foProdDetailMDTV.btModify.disabled = true;
	document.foProdDetailMDTV.btRemove.disabled = true;
	document.foProdDetailMDTV.btCopy.disabled = true;
	document.foProdDetailMDTV.btHerpair.disabled = true;
	document.foProdDetailMDTV.btStart.disabled = true;

	//To  enable all button if any of the box have status  completed
	if(document.foProdDetailMDTV.hdnMDTVOrderStatus.value==true){
		document.foProdDetailMDTV.btModify.disabled = false;
		document.foProdDetailMDTV.btRemove.disabled = false;
		document.foProdDetailMDTV.btCopy.disabled = false;
		document.foProdDetailMDTV.btHerpair.disabled = false; 
		document.foProdDetailMDTV.btRefresh.disabled =false;
		document.foProdDetailMDTV.btStart.disabled = false;
	}
	
	var vBoxId = document.foProdDetailMDTV.cmbBoxType.value;
    if(vBoxId == <%=GAfeConstants.MDTV_DIGICARD_PRODUCT%>)
    {
          document.foProdDetailMDTV.txtSmartSN.disabled = false;  
     }
    else
    {
          document.foProdDetailMDTV.txtSmartSN.disabled = true; 
     }

	
	<%if(null != bConfirmPairFlag){%>
	
    fnShowConfirmPopup();
 <%}%>
}


//===============================================================
//Function Name: fnSelectPackList(vProductListLength,vSelectedPacks)
//Description	: This method will obtain the list of all the packs 
//for a already provisioned box and select them in the list box.
//Called When  : Called when radio button is clicked for prov. box
//Input Param	: vProductListLength,vSelectedPacks
//Output Param	: None
//================================================================
function fnSelectPackList(vProductListLength,vSelectedPacks){
/*All the selected packs have to be split into an array 
and on the basis of those select the list items in the listbox*/

	var alProd = vSelectedPacks.split('/');
	
	for(k=0 ; k < alProd.length ; k++){
		
 		for(j=0 ; j < vProductListLength ; j++){
 			
			var vSelectProduct = 
			document.foProdDetailMDTV.productList.options[j].value;
				if(alProd[k] == vSelectProduct){
					
				document.foProdDetailMDTV.productList.options[j].selected=true;
				}
		}
	}
}  

//=================================================================
//Function Name: fnModify_Product()
//Description	: Enables the Products table
//Called When  : Called when Modify Product button is clicked
//Output Param	: None
//return       : None
//================================================================
function fnModify_Product(){
/*In this method the product list will be enabled and modify, herpair and 
 * remove buttons will be disabled. Also set a hidden value field to 
  	Wijzig_Product so that when start is clicked this scenario can be 
  	identified. 
 */    
	document.foProdDetailMDTV.productList.disabled = false;
	document.foProdDetailMDTV.btModify.disabled = true;
	document.foProdDetailMDTV.btHerpair.disabled = true;
	document.foProdDetailMDTV.btRemove.disabled = true;
	document.foProdDetailMDTV.hdnActualScenario.value = 
		"<%=GAfeConstants.Wijzig_Product%>";
		
}
//=================================================================
//Function Name: fnSubmit()
//Description	: Confirmation for pairing happens from this page
//Called When  : Called on click of START button or Terug button
//Input Param	: strAction
//Output Param	: None
//return       : None
//================================================================
function fnSubmit(strAction){
/* In case of Change Product condtion open a popup confirming 
 * if CAS modification product has to be made.
 */

 
 var vForm = document.foProdDetailMDTV;
 if (document.foProdDetailMDTV.hdnActualScenario.value 
			== "<%=GAfeConstants.Wijzig_Product%>"){
	 window.showModalDialog("<%= strAfeJspPath + GAfeFilePaths.strConfirmMDTVPopUpJSPPath %>?ButtonClicked=M",window,"dialogHeight=25;dialogWidth=40;resizeable=no;scrolling=no");
	}
 else{
	  if(!bIsDigiboxValid())
	 {
	     return false;
	 }
	 if(strAction == "Start")
	 {
	         document.foProdDetailMDTV.hdnPageAction.value = "<%=GAfeConstants.KEY_StartClicked%>";
	         document.foProdDetailMDTV.hdnMDTVScenario.value = "<%=GAfeConstants.iScenarioActiveer%>";
	         vForm.hdnMDTVAction.value = "<%=GAfeConstants.Start%>";
	         vForm.action = "<%=strServletPath%>";
	         vForm.submit();
	 }
 }
}
//=================================================================
//Function Name: fnCallBack()
//Description	: Call back from MultiDTVConfirmations.jsp
//Input Param	: strAction
//Output Param	: None
//return       : None
//================================================================
function fnCallBack(strAction){

	if(strAction == "<%=GAfeConstants.Terug%>")
    {
    	document.foProdDetailMDTV.hdnActualScenario.value = null;
        fnEnableButtons();
        
    }
	else if(strAction == "<%=GAfeConstants.Wijzig_Product%>")
    {
        document.foProdDetailMDTV.btModify.disabled = true;
        document.foProdDetailMDTV.btRemove.disabled = true;
        document.foProdDetailMDTV.btHerpair.disabled = true;
        document.foProdDetailMDTV.btTerug.disabled = true;
        document.foProdDetailMDTV.btRefresh.disabled = true;
        document.foProdDetailMDTV.btStart.disabled = true;
        document.foProdDetailMDTV.hdnMDTVAction.value = "<%=GAfeConstants.Wijzig_Product%>";
        document.foProdDetailMDTV.submit();
    }
	else  if(strAction == "<%=GAfeConstants.BUTTON_VERWIJDER%>")
    {
        document.foProdDetailMDTV.btModify.disabled = true;
        document.foProdDetailMDTV.btRemove.disabled = true;
        document.foProdDetailMDTV.btHerpair.disabled = true;
        document.foProdDetailMDTV.btTerug.disabled = true;
        document.foProdDetailMDTV.btRefresh.disabled = true;
        document.foProdDetailMDTV.btStart.disabled = true;
        document.foProdDetailMDTV.hdnMDTVAction.value = "<%=GAfeConstants.BUTTON_VERWIJDER%>";
        document.foProdDetailMDTV.submit();
    }
	else if(strAction == "<%=GAfeConstants.Herpair%>")
    {
        document.foProdDetailMDTV.btModify.disabled = true;
        document.foProdDetailMDTV.btRemove.disabled = true;
        document.foProdDetailMDTV.btHerpair.disabled = true;
        document.foProdDetailMDTV.btTerug.disabled = true;
        document.foProdDetailMDTV.btRefresh.disabled = true;
        document.foProdDetailMDTV.btStart.disabled = true;
        document.foProdDetailMDTV.hdnMDTVAction.value = "<%=GAfeConstants.Herpair%>";
        document.foProdDetailMDTV.submit();
    }
}
//=================================================================
//Function Name: fnRemove()
//Description	: Removes selected row
//Called When  : Called when Remove button is clicked
//Input Param	: None
//Output Param	: None
//return       : None
//================================================================
function fnRemove()
{
 document.foProdDetailMDTV.btStart.disabled = true;
 document.foProdDetailMDTV.btHerpair.disabled = true;
 document.foProdDetailMDTV.btModify.disabled = true;
 document.foProdDetailMDTV.btRemove.disabled = true;
 document.foProdDetailMDTV.btTerug.disabled = true;
 document.foProdDetailMDTV.btRefresh.disabled = true;
 window.showModalDialog("<%= strAfeJspPath + GAfeFilePaths.strConfirmMDTVPopUpJSPPath %>?ButtonClicked=R",window,"dialogHeight=25;dialogWidth=40;resizeable=no;scrolling=no");
}
//=================================================================
//Function Name:  fnEnableButtons()
//Description	: Enables all the buttons on the screen
//Called When  : Called when back button is clicked
//Input Param	: None
//Output Param	: None
//return       : None
//================================================================
function fnEnableButtons()
{
	<%if(bPermMdfyProd)
    {   %>
        document.foProdDetailMDTV.btModify.disabled = false;
	<%}
    if(bPermRemProd)
    {   %>
        document.foProdDetailMDTV.btRemove.disabled = false;
   <% }
    if(bPermHerProd)
    {   %>
        document.foProdDetailMDTV.btHerpair.disabled = false;
    <%}
    if(bPermTerug)
    {   %>
        document.foProdDetailMDTV.btTerug.disabled = false;
    <%}
    if(bPermRefresh)
    {   %>
        document.foProdDetailMDTV.btRefresh.disabled = false;
    <%}   %>
}

//=================================================================
//Function Name: fnHerpair()
//Description	: Herpairs
//Called When  : Called when Herpair button is clicked
//Input Param	: None
//Output Param	: None
//return       : None
//================================================================
function fnHerpair()
{
 document.foProdDetailMDTV.btStart.disabled = true;
 document.foProdDetailMDTV.btModify.disabled = true;
 document.foProdDetailMDTV.btRemove.disabled = true;
 document.foProdDetailMDTV.btHerpair.disabled = true;
 document.foProdDetailMDTV.btTerug.disabled = true;
 document.foProdDetailMDTV.btRefresh.disabled = true;
 window.showModalDialog("<%= strAfeJspPath + GAfeFilePaths.strConfirmMDTVPopUpJSPPath %>?ButtonClicked=H",window,"dialogHeight=25;dialogWidth=40;resizeable=no;scrolling=no");
}
//=================================================================
//Function Name: fnRefresh()
//Description	: sets the hdnMDTVAction as Refresh button and submit the page
//Called When  : Called on click of Refresh button
//Input Param	: None
//Output Param	: None
//return       : None
//================================================================
function fnRefresh()
{
var strSelectedMDTVIdentifierValue=fnGetSelectedValueForIdentifier();
document.foProdDetailMDTV.hdnMultiDTVIdentifierValue.value=strSelectedMDTVIdentifierValue;
document.foProdDetailMDTV.hdnMDTVAction.value = "<%=GAfeConstants.REFRESH%>";
document.foProdDetailMDTV.submit();
}
//=================================================================
//Function Name: fnGetSelectedValueForIdentifier()
//Description	: Gets the selected value in the identifier
//Called When  : Called on fnLoad
//Input Param	: None
//Output Param	: None
//================================================================
function fnGetSelectedValueForIdentifier()
{
	var vForm=document.foProdDetailMDTV;
	//var strSelectedMDTVIdentifierValue1 = element.options[element.selectedIndex].text;
	for(var i = 0 ;i < vForm.selectedmultidtv.length ; i++)
		{
		if(vForm.selectedmultidtv.options[i].selected)
		{
			var strSelectedMDTVIdentifierValue2=vForm.selectedmultidtv.options[i].text;
			
		}
	}
	
	return(strSelectedMDTVIdentifierValue2);
}
//=================================================================
//Function Name: fnShowConfirmPopup()
//Description	: Displays the message
//Called When  : Called on fnLoad
//Input Param	: None
//Output Param	: None
//================================================================
var scenario = '';
function fnShowConfirmPopup()
{
 var vForm = document.foProdDetailMDTV;
 var iScenarioId;

 vForm.hdnMDTVScenario.value = <%=iScenarioId%>;
 iScenarioId = vForm.hdnMDTVScenario.value;

 vForm.btHerpair.disabled = true;
 vForm.btRemove.disabled = true;
 <%if(bPermStart)
 {   %>
     vForm.btStart.disabled = false;
 <%}%>

 if(iScenarioId == <%=GAfeConstants.iScenarioVerwijder%>)
 {
     scenario = "Verwijder";
 }
 else if(iScenarioId == <%=GAfeConstants.iScenarioHerpair%>)
 {
     scenario = "Herpair";
 }

 //Resetting textboxes
 if(iScenarioId == <%=GAfeConstants.SCENARIO_ADDBOX%>)
 {
     vForm.txtSTBCA.disabled = false;
     vForm.txtSTBMAC.disabled = true;
 }
 else if( iScenarioId == <%=GAfeConstants.iScenarioHerpair%> )
 {
     vForm.txtSTBCA.disabled = true;
 }

 else if( iScenarioId == <%=GAfeConstants.iScenarioVerwijder%> )
 {
     fnEnablePairedBoxes();
     vForm.txtSTBCA.disabled = true;
 }
 else
 {
     vForm.txtSTBCA.readOnly = true;
     vForm.txtSTBMAC.readOnly = true;
 }
	//Check whether pop up ConfirmPair or ConfirmUnpair jsp
 <% if( null != strBoxStatus && strBoxStatus.equalsIgnoreCase("1"))
 {%>
 	//If the box is blacklisted, then display a popup confirming if the box has to be provisioned
     if (confirm('<%=GResourceBundle.getText("alert_ConfirmPopup")%>'))
     {
          <%if(null != bConfirmPairFlag && bConfirmPairFlag.booleanValue()){%>
             window.showModalDialog("<%= strAfeJspPath + GAfeFilePaths.strConfirmPairJSPPath %>",window,"dialogHeight=25;dialogWidth=40;resizeable=no;scrolling=no");
         <%}else{%>
             window.showModalDialog("<%= strAfeJspPath + GAfeFilePaths.strConfirmUnpairJSPPath %>",window,"dialogHeight=20;dialogWidth=40;resizeable=no;scrolling=no");
         <%}%>
     }
     else return false;
<%}
 else if(null != strBoxStatus && strBoxStatus.equalsIgnoreCase("0"))
 {

     if(null != bConfirmPairFlag && bConfirmPairFlag.booleanValue()){%>
             window.showModalDialog("<%= strAfeJspPath + GAfeFilePaths.strConfirmPairJSPPath %>",window,"dialogHeight=25;dialogWidth=40;resizeable=no;scrolling=no");
     <%}else{%>
             window.showModalDialog("<%= strAfeJspPath + GAfeFilePaths.strConfirmUnpairJSPPath %>",window,"dialogHeight=20;dialogWidth=40;resizeable=no;scrolling=no");
     <%}%>
<%}%>
}
//=============================================================================
//Function Name: fnCallbackFromPopup()
//Description	: Function to call back from the pairing confirmation popup
//Input Param	: strAction
//Input Param	: iRadExtraCostVal
//Input Param	: strIBOMACID
//Input Param	: strActivationUser
//Output Param	: None
//============================================================================
function fnCallbackFromPopup(strAction, iRadExtraCostVal,strIBOMACID,strActivationUser)
{
 document.foProdDetailMDTV.hdnActivationUser.value = strActivationUser;
 document.foProdDetailMDTV.hdnMDTVAction.value = strAction;
 document.foProdDetailMDTV.hdnRadioBtnNRC.value = iRadExtraCostVal;
 if (0 != strIBOMACID)
 {
     document.foProdDetailMDTV.hdnNewMacId.value = strIBOMACID;
 }
 document.foProdDetailMDTV.submit();
}
//=================================================================
//Function Name: fnEnableStart()
//Description	: Enables 'Start' button if any product is selected
//Called When  : Textboxes Clicked
//Input Param	: selectProd
//Output Param	: None
//================================================================
function fnEnableStart(selectProd)
{
 var j;
 var vSelectProduct = selectProd.getElementsByTagName('TD');
 //Begin Modify v1.00
 var orderStatus = vSelectProduct[6].innerHTML;
 //End Modify v1.00
 var vProductListLength = document.foProdDetailMDTV.productList.options.length;

 fnGetSelectedValueForIdentifier();

 //Begin Add v1.00
 var vBoxId = document.foProdDetailMDTV.cmbBoxType.value;
 if(vBoxId == <%=GAfeConstants.MDTV_DIGICARD_PRODUCT%>)
 {
	 document.foProdDetailMDTV.txtSmartSN.disabled = false;  
 }
 else
 {
	 document.foProdDetailMDTV.txtSmartSN.disabled = true; 
 }
 // End Add v1.00
 //Begin Add v1.00
 if(vBoxId != <%=GAfeConstants.MDTV_DIGICARD_PRODUCT%> )
	 {
	 document.foProdDetailMDTV.txtSmartSN.value = "";
	 }
 // End Add v1.00	 
 if(orderStatus == 'NEW')
	{
	 document.foProdDetailMDTV.txtSTBCA.disabled= false;
	 document.foProdDetailMDTV.cmbBoxType.disabled=false;
	 document.foProdDetailMDTV.hdnActualScenario.value = null;
     document.foProdDetailMDTV.btModify.disabled = true;
     document.foProdDetailMDTV.btRemove.disabled = true;
     document.foProdDetailMDTV.btHerpair.disabled = true;
	 document.foProdDetailMDTV.productList.disabled = false;
     document.foProdDetailMDTV.btCopy.disabled = true;

		for(j = 0; j < vProductListLength ; j++)
		{
		document.foProdDetailMDTV.productList.options[j].selected=false;
		}

    
     var vSTBCA = document.foProdDetailMDTV.txtSTBCA;
     var vProducts = document.foProdDetailMDTV.txtProducts;
     //Begin Add v1.00
     var vSmartcardSN = document.foProdDetailMDTV.txtSmartSN;
     //End Add v1.00
     if( !fnValidateNull(vSTBCA) || !fnValidateNull(vProducts))
     {
         document.foProdDetailMDTV.btStart.disabled = true;
     }
     else
     {
         <%if(bPermStart)
         {  %>
            //Begin Modify v1.00
            if(((vBoxId == <%=GAfeConstants.MDTV_DIGICARD_PRODUCT%>) && fnValidateNull(vSmartcardSN)) || ((vBoxId != <%=GAfeConstants.MDTV_DIGICARD_PRODUCT%>) && !fnValidateNull(vSmartcardSN)) )
            {
           	  document.foProdDetailMDTV.btStart.disabled = false;
            }
            else
            {
            	document.foProdDetailMDTV.btStart.disabled = true;  
            }
            //End Modify v1.00
         <%}     %>
     }
 }
}
//=================================================================
//Function Name: fnValidateNull()
//Description	: Function to validate if the entered value is not null.
//Called When  : Called on click  button
//Input Param	: field,strNameOfField
//Output Param	: None
//return       : None
//================================================================
function fnValidateNull(strNameOfField)
{
	if( strNameOfField.value == '' )
	{
		return (false);
	}
	var checkStr = fnTrim(strNameOfField);
	if(checkStr=='')
	{
		return (false);
	}
	return (true);
}
//=================================================================
//Function Name: fnTerug()
//Description	: sets the hdnMDTVAction as Refresh button and submit the page
//Called When  : Called on click of Refresh button
//Input Param	: None
//Output Param	: None
//return       : None
//================================================================
function fnTerug()
{
 document.foProdDetailMDTV.hdnMDTVAction.value = "<%=GAfeConstants.Terug%>";
 document.foProdDetailMDTV.submit();
}
//=================================================================
//Function Name: fnCopyProd()
//Description	: Overwrites customer's old products with new
//Called When  : Called on click of Copy Products button
//Output Param	: None
//return       : None
//================================================================
function fnCopyProd()
{

	//Define the variables
	var vProdList = new Array();
	var vProducts='';
	var vProdLength = 0;
	var productListlength = 0;
	var jCount=0;
	var iCount=0;

	// Store the index value of the packs
	productListlength = document.foProdDetailMDTV.productList.options.length;

	//Copy the index value of the selected products in an array
	 for(iCount=0; iCount < productListlength ; iCount++)
	 {
	     if(document.foProdDetailMDTV.productList.options[iCount].selected==true)
		    {
	         vProdList.push(document.foProdDetailMDTV.productList.options[iCount].value);
	     }
	 }

	/*Append '/' in case of multiple packs between each package's index id 
	and in case of last package stop appending '/' */ 
	 for(jCount=0; jCount < vProdList.length; jCount++)
	 {
	     if( jCount < vProdList.length - 1)
	     {
	         vProducts = vProducts + vProdList[jCount] + "/";
	     }
	     else
	     {
	         vProducts = vProducts + vProdList[jCount];
	     }
	 }

	//For showing the selected packs in the data grid
	//Store the total number of rows in the data grid in tabRows
	var tabRows = document.getElementById('addbox').getElementsByTagName('tr');
	var rowCount = tabRows.length;
	
	/*In case of two rows i.e. first row being labels and second rows being an 
	empty row(no boxes are provisioned),if the radiobutton is checked, then 
	in the new row display the value of the index values of selected packs*/
	if( rowCount == 2)
	{
		if(document.foProdDetailMDTV.rdButton.checked)
		{
         var tableName = 'row'+1;
         var selectProd = document.getElementById(tableName);
         //Update the value of packs in case this is the first value in the grid
         document.foProdDetailMDTV.txtProducts.value = vProducts;
         fnEnableStart(selectProd);
		}
	}
	/*In case of already provisioned boxes present, then depending on the type 
	of provisioned/non-provisioned box update the packs for the box*/
 	else
	{
		for(i=0;i < rowCount-1; i++)
		{
			if(document.foProdDetailMDTV.rdButton[i].checked)
			{
             var tableName = 'row'+(i+1);
				var selectProd = document.getElementById(tableName);
				var vSelectProduct = selectProd.getElementsByTagName('TD');
				//Begin Modify v1.00
				var status = vSelectProduct[6].innerHTML;
				//End Modify v1.00
				if( status == "NEW")
				{
					document.foProdDetailMDTV.txtProducts.value = vProducts;
					fnEnableStart(selectProd);
				}
				else
				{
				//Hidden value to be used in case Herpair/modify button
                 document.foProdDetailMDTV.hdnSelectedProd.value = vProducts;
                 //Update the value for already prov boxes.
                 	//Begin Modify v1.00
					vSelectProduct[5].innerHTML = vProducts;
					//End Modify v1.00
					<%if(bPermStart)
                 {    %>
					    document.foProdDetailMDTV.btStart.disabled = false;
                <% }%>
				}
			}
		}
	}
}
//=================================================================
//Function Name: bIsDigiboxValid()
//Description	: Checks if input Digibox number/Mac id are non empty and in valid format
//Input Param	: None
//Output Param	: None
//return       : boolean
//================================================================
function bIsDigiboxValid()
{
 var vForm = document.foProdDetailMDTV;
 if(!bCheckDigiboxNoFormat(vForm.txtSTBCA.value))
 {
     alert('<%=GResourceBundle.getText("invalidDigiboxNo")%>');
     return false;
 }
 else
	{
     return true;
	}
}
//=================================================================
//Function Name: bIsDigiboxValid()
//Description	: Checks if input Digibox number/Mac id are non empty and in valid format
//Input Param	: None
//Output Param	: None
//return       : boolean
//================================================================
function bIsDigiboxValid()
{
var vForm = document.foProdDetailMDTV;
if(!bCheckDigiboxNoFormat(vForm.txtSTBCA.value))
{
  alert('<%=GResourceBundle.getText("invalidDigiboxNo")%>');
   return false;
}
else
	{
   return true;
	}
}

//=================================================================
//Function Name: bCheckDigiboxNoFormat()
//Description	: To check if input SmartCard Number is of valid format.
//Input Param	: SCNo
//Output Param	: None
//return       : boolean
//================================================================
function bCheckDigiboxNoFormat(strDigiboxNo)
{
  var bReturnVal;
  bReturnVal = bCheckSCNoFormat(strDigiboxNo)
  return bReturnVal;
}
//=================================================================
//Function Name: bCheckSCNoFormat()
//Description	: To check if input SmartCard Number is of valid format.
//Input Param	: SCNo
//Output Param	: None
//return       : boolean
//================================================================
function bCheckSCNoFormat(strSCNo)
{
  var ulChecksum;
  var vForm = document.foProdDetailBDTV;
  var regexp = /^([0-9]){12}$/;
  var strSCNo = fnTrim(strSCNo);
  var last2Digits;

  if(regexp.test(strSCNo))    //check if it is exactly 12 digit number
  {
	  return true;
  }
  else 
  {
      return false;
  }
}
//=================================================================
//Function Name: round()
//Input Param	: strValue
//Output Param	: None
//================================================================
function round(strValue)
{
  var roundNo = Math.round(strValue - 0.5);
  return roundNo;
}
//=================================================================
//Function Name: fnColorRow()
//Description	: color the selected row.
//Called When  : fnSubmit
//Input Param	: None
//Output Param	: None
//return       : Boolean
//================================================================
var lastElement='';
var lastElementStyle = '';
function fnColorRow()
{
	var obj = event.srcElement.parentElement;
	var srcElement = obj;
	var srcElem = obj;
 if(obj.tagName == 'TD')
 {
     srcElement = obj.parentElement;
		srcElem = obj.parentElement;
 }

	if( lastElement != "" )
	{
		 lastElement.bgColor  = lastElementStyle;
	}

	if(obj.tagName != 'TD')
	{
		lastElement = obj
		lastElementStyle = obj.bgColor;
	}
	else
	{
		lastElement = obj.parentElement;
		lastElementStyle = obj.parentElement.bgColor;
	}

 //Set the Back ground color.
	srcElem.bgColor = "#ffffff";

 //Highlight the radio button.
	if(srcElem.tagName == 'TBODY')
	{
       //Do nothing
	}
	else if(srcElem.cells[0].children[0]!= undefined)
	{
		 if(srcElem.cells[0].children[0].tagName=='INPUT' && srcElement != srcElem.cells[0].children[0])
		 {
         //Check if not disabled then highlight.
			if(!srcElem.cells[0].children[0].disabled)
			{
              if(srcElem.cells[0].children[0].checked==true && srcElem.cells[0].children[0].type == "checkbox")
              {
                      srcElem.cells[0].children[0].checked=false;
              }
              else if (srcElem.cells[0].children[0].checked==false)
              {
                      srcElem.cells[0].children[0].checked=true;
              }
          }
		 }
	}
}
//=================================================================
//Function Name: fnDisableTextBoxes()
//Description	: Disables the testboxes
//Called When  : Called on selecting provisoned row
//Input Param	: None
//Output Param	: None
//================================================================
function fnDisableTextBoxes()
{
document.foProdDetailMDTV.txtSTBCA.disabled= true;
document.foProdDetailMDTV.cmbBoxType.disabled=true;
}
</SCRIPT>
<%-- ****************************  JavaScript Section Ends ************************************* --%>	

