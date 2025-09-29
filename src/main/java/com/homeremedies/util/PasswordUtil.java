package com.homeremedies.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordUtil {
    public static String hash(String plain) {
        return BCrypt.hashpw(plain, BCrypt.gensalt(12));
    }

    public static boolean verify(String plain, String hashed) {
        return BCrypt.checkpw(plain, hashed);
    }
}
