module top_module(RS,clk,q,qbar);input [1:0] RS;
  output q,qbar;
  input clk;
  reg q,qbar;
  
  always @(posedge clk) begin
    case (RS)
      2'd0: q = q;
      2'd1: q = 0;
      2'd2: q = 1;
      2'd3: q = 1'bx;
    endcase
    qbar = ~q;
  end
endmodule