module top_module(
  input [3:0] A,
  input [3:0] B,
  input [1:0] control,
  output reg [3:0] result,  // Changed output to reg type
  output carry_out
);wire [3:0] add_out;
wire [3:0] sub_out;
wire [3:0] and_out;
wire [3:0] or_out;

assign add_out = A + B;
assign sub_out = A - B;
assign and_out = A & B;
assign or_out = A | B;

assign carry_out = (control == 2'b00) ? add_out[4] : 1'b0; // Ensure proper carry_out handling

always @(*) begin
  case (control)
    2'b00: result = add_out[3:0];
    2'b01: result = sub_out[3:0];
    2'b10: result = and_out[3:0];
    2'b11: result = or_out[3:0];
    default: result = 4'b0000; // Handle default case
  endcase
end

endmodule