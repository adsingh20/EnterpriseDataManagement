package com.github.elizabetht.repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import com.github.elizabetht.model.Question;
import com.github.elizabetht.util.DbUtil;
import com.mysql.jdbc.CallableStatement;

public class StudentRepository {
	private Connection dbConnection;
	
	public StudentRepository() {
		dbConnection = DbUtil.getConnection();
	}
	
	public void saveClient(String userName, String clientName) {
		try {
			userName="admin";
			System.out.println("saveClient Method in StudentRepository");
			System.out.println("CLient Name"+clientName);
			//PreparedStatement prepStatement = dbConnection.prepareStatement("insert into student(userName, password, firstName, lastName, dateOfBirth, emailAddress) values (?, ?, ?, ?, ?, ?)");
			java.sql.CallableStatement cStmt = dbConnection.prepareCall("{call neuroid.ins_upd_client(?,?,?,?)}");
			Object operation;
			cStmt.setNull(1, Types.NULL);
			cStmt.setString(2, clientName);
			cStmt.setString(3, userName);
			cStmt.registerOutParameter(4, Types.VARCHAR);
			//int results = cStmt.executeUpdate();
			cStmt.execute();
			String result=cStmt.getString(4);
			if(result!=null) {
				System.out.println("No of result"+result);
				//System.out.println("Callable Statement"+cStmt.getObject(4));
				//ResultSet rs = cStmt.getResultSet();
	
			}else {
				System.out.println("Success");
			}
	
		} catch (SQLException e) {
			System.out.println(e.getSQLState());
		} 
	}
	
	public boolean findByUserName(String userName) {
		try {
			PreparedStatement prepStatement = dbConnection.prepareStatement("select count(*) from student where userName = ?");
			prepStatement.setString(1, userName);
		
						
			ResultSet result = prepStatement.executeQuery();
			if (result != null) {	
				while (result.next()) {
					if (result.getInt(1) == 1) {
						return true;
					}				
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public boolean findByLogin(String userName, String password) {
		try {
			PreparedStatement prepStatement = dbConnection.prepareStatement("select password from users where loginID = ?");
			prepStatement.setString(1, userName);			
			
			ResultSet result = prepStatement.executeQuery();
			if (result != null) {
				while (result.next()) {
					if (result.getString(1).equals(password)) {
						return true;
					}
				}				
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public List<Question> searchQuestion(String questionText) {
		// TODO Auto-generated method stub
		List<Question> questions = new ArrayList<Question>();
		return questions;
	}

	public void addQuestion(String parameter) {
		// TODO Auto-generated method stub
		
	}

}
