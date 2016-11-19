package com.inkey.common.exception;
/**
 * 业务错误异常
 */
public class ErrorException extends RuntimeException {

	private static final long serialVersionUID = 1L;

	public ErrorException(String message) {
        super(message);
    }

	public ErrorException(String message, Object... args) {
		super(String.format(message,args));
	}

    public ErrorException(String message, Throwable cause) {
        super(message,  cause);
    }
    
    

}
