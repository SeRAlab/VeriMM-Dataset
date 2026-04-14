module top_module(input wire [3:0] a, input wire [3:0] b, input wire [1:0] op, output reg [3:0] result);always @ (a, b, op)
begin
    case(op)
        2'b00: result <= a + b; // Addition
        2'b01: result <= a - b; // Subtraction
        default: result <= 4'b0000; // Default to 0
    endcase
end

endmodule