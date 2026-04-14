module top_module(
    input [31:0] a,
    input [31:0] b,
    input [1:0] op,
    output reg [31:0] c
);always @*
begin
    case(op)
        2'b00: c = a + b; // addition
        2'b01: c = a - b; // subtraction
        2'b10: c = a * b; // multiplication
        2'b11: c = a / b; // division
        default: c = 0;   // default to 0 if op is invalid
    endcase
end

endmodule