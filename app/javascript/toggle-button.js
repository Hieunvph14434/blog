function toggleReplyForm(commentId) {
    const replyForm = document.getElementById(`reply-form-${commentId}`);
    const replyButton = document.getElementById(`reply-button-${commentId}`);

    // Check the current display state of the reply form
    if (replyForm.style.display === "none" || replyForm.style.display === "") {
        replyForm.style.display = "block"; // Show the form
        replyButton.style.display = "none"; // Hide the reply button
    } else {
        replyForm.style.display = "none"; // Hide the form
        replyButton.style.display = "block"; // Show the reply button
    }
}