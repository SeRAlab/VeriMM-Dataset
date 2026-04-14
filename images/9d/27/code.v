module top_module(clk, rst, bin, gray);input clk, rst;
  input [3:0] bin;
  output [3:0] gray;
  reg [3:0] gray_next;
  
  always @(posedge clk) begin
    if (rst) begin
      gray_next <= 4'b0;
    end else begin
      gray_next[0] <= bin[0];
      gray_next[1] <= bin[0] ^ bin[1];
      gray_next[2] <= bin[1] ^ bin[2];
      gray_next[3] <= bin[2] ^ bin[3];
    end
  end
  
  assign gray = gray_next;
endmodule