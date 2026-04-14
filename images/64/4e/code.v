module top_module(input [7:0] num1, num2, input control, output reg [7:0] result, output reg carry);reg [8:0] temp;

    always @(*) begin
        if (control == 1'b0) begin  // addition operation
            temp = num1 + num2;
            carry = temp[8];
            result = temp[7:0];
        end
        else begin  // subtraction operation
            temp = {1'b0, num1} - {1'b0, num2}; // ensure 1-bit width for carry
            carry = temp[8];
            result = temp[7:0];
        end
    end
endmodule