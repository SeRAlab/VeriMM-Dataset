module top_module(
    input wire [7:0] a,
    input wire [7:0] b,
    input wire [1:0] op,
    output reg [15:0] result
);always @* begin
    case (op)
        2'b00: result = a + b; // addition
        2'b01: result = a - b; // subtraction
        2'b10: result = a * b; // multiplication
        2'b11: result = a / b; // division
    endcase
end

endmodule