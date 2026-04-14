module top_module(
    input signed [3:0] op1,
    input signed [3:0] op2,
    input [1:0] op,
    output reg signed [3:0] result
);always @(*)
    case(op)
        2'b00: result = op1 + op2; // Addition
        2'b01: result = op1 - op2; // Subtraction
        2'b10: result = op1 * op2; // Multiplication
        2'b11: begin                // Division
                    if(op2 == 0) begin
                        result = 4'bX; // Indeterminate result
                    end
                    else if((op1 == -8) && (op2 == -1)) begin
                        result = 4'bX; // Overflow condition
                    end
                    else begin
                        result = op1 / op2; // Integer division
                    end
               end
    endcase

endmodule