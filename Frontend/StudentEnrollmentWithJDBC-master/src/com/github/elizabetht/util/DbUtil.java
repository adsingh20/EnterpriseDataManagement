package com.github.elizabetht.util;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DbUtil {
	private static Connection dbConnection = null;

	public static Connection getConnection() {
		if (dbConnection != null) {
			return dbConnection;
		} else {
			try {
				System.out.println("In Connection");
				InputStream inputStream = DbUtil.class.getClassLoader()
						.getResourceAsStream("db.properties");
				Properties properties = new Properties();
				if (properties != null) {
					properties.load(inputStream);

					String dbDriver = properties.getProperty("dbDriver");
					String connectionUrl = properties
							.getProperty("connectionUrl");
					String userName = properties.getProperty("userName");
					String password = properties.getProperty("password");

					Class.forName(dbDriver).newInstance();
					System.out.println("");
					System.out.println("Connection URL"+connectionUrl);
					dbConnection = DriverManager.getConnection(connectionUrl,
							userName, password);
					System.out.println("Connection created");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
			return dbConnection;
		}
	}
}
