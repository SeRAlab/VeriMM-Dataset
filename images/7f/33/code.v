module top_module(
    input [15:0] inputMsg,
    input inputValid,
    output reg [15:0] outputMsg,  // Changed to 'reg'
    output reg outputValid         // Changed to 'reg'
);reg [15:0] storedMsg;
    reg storedValid;

    always @(*) begin
        if (inputValid) begin
            storedMsg = inputMsg;
            storedValid = 1;
        end else begin
            storedValid = 0; // Clear storedValid if inputValid is low
        end
        outputMsg = storedMsg;
        outputValid = storedValid & inputValid;
    end

endmodule