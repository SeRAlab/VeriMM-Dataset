module top_module(
  input [7:0] in,
  input [2:0] shift_amt,
  output reg [7:0] out // Change output to reg type
);always @(*) begin
    case(shift_amt)
      3'b000: out = in; // no shift
      3'b001: out = {in[6:0], 1'b0}; // shift left by 1
      3'b010: out = {in[5:0], 2'b00}; // shift left by 2
      3'b011: out = {in[4:0], 3'b000}; // shift left by 3
      3'b100: out = {in[3:0], 4'b0000}; // shift left by 4
      3'b101: out = {1'b0, in[7:1]}; // shift right by 1
      3'b110: out = {2'b00, in[7:2]}; // shift right by 2
      3'b111: out = {3'b000, in[7:3]}; // shift right by 3
      default: out = 8'b00000000; // default case to handle any unexpected shifts
    endcase
  end

endmodule