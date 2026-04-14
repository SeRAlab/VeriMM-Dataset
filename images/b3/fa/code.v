module top_module(
  input [3:0] a,
  input [3:0] b,
  input clk,             // Added clock input
  output reg [7:0] product
);reg [3:0] a_shift;
reg [3:0] b_shift;
reg [3:0] a_shift_reg1;
reg [3:0] a_shift_reg2;
reg [3:0] a_shift_reg3;
reg [3:0] b_shift_reg1;
reg [3:0] b_shift_reg2;
reg [3:0] b_shift_reg3;
wire [3:0] adder1_out;
wire [3:0] adder2_out;
wire [3:0] adder3_out;
wire [3:0] adder4_out;

// Fixed concatenation by specifying the width of the shift
assign adder1_out = a_shift_reg1 + (b_shift_reg3 << 1);
assign adder2_out = a_shift_reg2 + (b_shift_reg2 << 1);
assign adder3_out = a_shift_reg3 + (b_shift_reg1 << 1);
assign adder4_out = a_shift + (b << 1);

always @(a or b) begin
  a_shift = {a[2:0], 1'b0};  // Corrected the last bit to be a 1-bit zero
  b_shift = {b[2:0], 1'b0};  // Corrected the last bit to be a 1-bit zero
end

always @(posedge clk) begin
  a_shift_reg1 <= a_shift_reg2;
  a_shift_reg2 <= a_shift_reg3;
  a_shift_reg3 <= a_shift;
  b_shift_reg1 <= b_shift_reg2;
  b_shift_reg2 <= b_shift_reg3;
  b_shift_reg3 <= b_shift;
end

assign product = {adder4_out, adder3_out[3:0]};

endmodule