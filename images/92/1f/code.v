module top_module(
  input wire [7:0] v,
  input wire [7:0] rnd,
  output wire [3:0] d);wire [8:0] s = {1'b0, v} + {5'b00000, rnd[3:0]};
  assign d = s[8] ? 4'd15 : s[7:4];

endmodule