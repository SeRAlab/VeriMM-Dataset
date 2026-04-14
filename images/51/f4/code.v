module top_module(
    input clk,
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);reg [2:0] shift_reg;
reg [7:0] a_reg;
reg [7:0] b_reg;
wire [15:0] product;
wire [8:0] sum;
wire carry;

assign product = a_reg * b_reg;
assign sum = product[7:0] + shift_reg;
assign carry = product[8] | sum[8];

always @(posedge clk) begin
    shift_reg <= {shift_reg[1:0], 1'b0};
    a_reg <= a;
    b_reg <= b;
end

assign s = sum[7:0];
assign overflow = carry;

endmodule