module top_module(
    input [5:0] alufn,
    input [15:0] a,
    input [15:0] b,
    output reg [15:0] com_out
  );reg [15:0] out;
  
  always @* begin
    out[0+0-:1] = 1'h0;
    if (alufn[1+0-:1] == 1'h1 & alufn[2+0-:1] == 1'h0) begin
      if (a == b) begin
        out[0+0-:1] = 1'h1;
      end
    end
    if (alufn[1+0-:1] == 1'h0 & alufn[2+0-:1] == 1'h1) begin
      if (a < b) begin
        out[0+0-:1] = 1'h1;
      end
    end
    if (alufn[1+0-:1] == 1'h1 & alufn[2+0-:1] == 1'h1) begin
      if (a <= b) begin
        out[0+0-:1] = 1'h1;
      end
    end
    out[1+14-:15] = 16'h0000;
    com_out = out;
  end
endmodule