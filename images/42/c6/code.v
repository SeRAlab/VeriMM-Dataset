module top_module(
    input [7:0] a,
    input [7:0] b,
    input [1:0] control,
    output reg [7:0] result
);always @(*) begin
    case(control)
        2'b00: result = a + b; // Addition
        2'b01: result = a - b; // Subtraction
        2'b10: result = a * b; // Multiplication
        2'b11: result = a / b; // Division
    endcase
end

endmodule