package net.slavus.web.controller;

public class DescriptionUniquenessViolationException extends RuntimeException {
    /**
	 *
	 */
	private static final long serialVersionUID = 1L;
	private String description;

    public DescriptionUniquenessViolationException(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
