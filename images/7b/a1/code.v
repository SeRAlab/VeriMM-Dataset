module top_module(
    input [31:0] data,
    input trigger,
    output reg [31:0] result
);reg [7:0] operand1;
    reg [7:0] operand2;
    reg [3:0] operator;
    
    always @(*) begin
        operand1 = data[7:0];
        operand2 = data[15:8];
        operator = data[23:16];
    end
    
    always @(posedge trigger) begin
        case(operator)
            4'b0000: result <= $signed(operand1) + $signed(operand2);
            4'b0001: result <= $signed(operand1) - $signed(operand2);
            4'b0010: result <= $signed(operand1) * $signed(operand2);
            4'b0011: begin
                        if (operand2 == 0) begin
                            result <= 32'h7FFFFFFF; // Maximum value for signed 32-bit integer
                        end else begin
                            result <= $signed(operand1) / $signed(operand2);
                        end
                     end
            default: result <= 0;
        endcase
        
        // Clamp result to maximum or minimum value if overflow or underflow occurs
        if (result > 32'h7FFFFFFF) begin
            result <= 32'h7FFFFFFF;
        end else if (result < 32'h80000000) begin
            result <= 32'h80000000;
        end
    end

endmodule