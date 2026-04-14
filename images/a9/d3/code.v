module top_module(
    input clk, reset,
    input [1:0] operation,
    input [7:0] operand1, operand2,
    output reg [7:0] result
);reg [7:0] temp_result; // temp variable to store the result of the operation

always @(posedge clk) begin
    if(reset) begin
        result <= 8'b0; // reset result to 0
        temp_result <= 8'b0; // reset temp_result to 0
    end
    else if(operation == 2'b00) begin // addition
        temp_result <= operand1 + operand2; // perform addition operation
        result <= temp_result; // output the result
    end
    else if(operation == 2'b01) begin // subtraction
        temp_result <= operand1 - operand2; // perform subtraction operation
        result <= temp_result; // output the result
    end
end

endmodule