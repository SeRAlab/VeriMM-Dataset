module top_module(
  input clk,
  input reset,
  input signed [7:0] a,
  input signed [7:0] b,
  output reg signed [7:0] s,
  output reg overflow
);reg signed [8:0] temp_sum;
  reg signed [7:0] a_ext;
  reg signed [7:0] b_ext;
  
  assign a_ext = (a[7] == 1) ? {8'b11111111, a} : {8'b00000000, a};
  assign b_ext = (b[7] == 1) ? {8'b11111111, b} : {8'b00000000, b};
  
  always @(posedge clk) begin
    if (reset) begin
      s <= 0;
      overflow <= 0;
    end
    else begin
      temp_sum <= a_ext + b_ext;
      s <= temp_sum[7:0];
      overflow <= (temp_sum[8] ^ temp_sum[7] ^ a_ext[7] ^ b_ext[7]);
    end
  end
  
endmodule