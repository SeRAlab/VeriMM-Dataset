module top_module(
    input [7:0] A,
    input [7:0] B,
    input [1:0] op,
    output reg [7:0] result
);wire [15:0] product;
wire [7:0] quotient;
wire [7:0] remainder;

assign product = A * B;
assign quotient = A / B;
assign remainder = A % B;

always @(*) begin
    case (op)
        2'b00: result = A + B;
        2'b01: result = A - B;
        2'b10: result = product[15:8];
        2'b11: result = quotient;
        default: result = 8'h00;
    endcase
end

endmodule