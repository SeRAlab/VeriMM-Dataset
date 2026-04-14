module top_module(clk, din, rst_b, dout);input din;
  input clk;
  input rst_b;
  output dout;

  reg r1_q, r2_q;
 
  assign dout = r2_q & din;
 
  always @ (posedge clk or negedge rst_b)
    if (!rst_b)
      begin
        r1_q <= 0;
        r2_q <= 0;
      end
    else
      begin
        r1_q <= din;
        r2_q <= r1_q;
      end

endmodule