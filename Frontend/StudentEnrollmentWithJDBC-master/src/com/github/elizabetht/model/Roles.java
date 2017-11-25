package com.github.elizabetht.model;

import java.util.HashMap;
import java.util.List;

public class Roles {
private String roleId;
private String roleName;

private HashMap<List<RoleFunction>,String> rolefunction;

public String getRoleId() {
	return roleId;
}

public void setRoleId(String roleId) {
	this.roleId = roleId;
}

public String getRoleName() {
	return roleName;
}

public void setRoleName(String roleName) {
	this.roleName = roleName;
}

public HashMap<List<RoleFunction>, String> getRolefunction() {
	return rolefunction;
}

public void setRolefunction(HashMap<List<RoleFunction>, String> rolefunction) {
	this.rolefunction = rolefunction;
}

}
