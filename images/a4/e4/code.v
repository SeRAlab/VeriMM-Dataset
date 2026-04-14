module top_module(
    input clk,
    input rst,
    input [7:0] a,
    input [7:0] b,
    input [5:0] alufn,
    output reg [0:0] z,
    output reg [0:0] v,
    output reg [0:0] n,
    output reg [7:0] s
  );reg [7:0] result;
  
  reg [7:0] xa;
  
  reg [7:0] xb;
  
  integer i;
  
  always @* begin
    result = 8'h00;
    xa = a;
    for (i = 1'h0; i < 4'h8; i = i + 1) begin
      xb[(i)*1+0-:1] = b[(i)*1+0-:1] ^ alufn[0+0-:1];
    end
    if (alufn[0+1-:2] == 2'h0 || alufn[0+1-:2] == 2'h1) begin
      result = xa + xb + alufn[0+0-:1];
    end else begin
      if (alufn[0+1-:2] == 2'h2) begin
        result = xa * xb;
      end
    end
    s = result;
    if (result == 8'h00) begin
      z = 1'h1;
    end else begin
      z = 1'h0;
    end
    n = result[7+0-:1];
    v = (xa[7+0-:1] & xb[7+0-:1] & (~result[7+0-:1])) | ((~xa[7+0-:1]) & (~xb[7+0-:1]) & result[7+0-:1]);
  end
endmodule