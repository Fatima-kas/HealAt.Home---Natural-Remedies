package com.homeremedies.util;

import java.security.SecureRandom;
import java.util.Base64;

public class TokenUtil {
    private static final SecureRandom secureRandom = new SecureRandom();

    // Generates URL-safe token; numBytes=32 gives ~43-char string
    public static String generateToken(int numBytes) {
        byte[] bytes = new byte[numBytes];
        secureRandom.nextBytes(bytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
    }
}
