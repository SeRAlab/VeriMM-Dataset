module top_module(d,q,clk,rst);input d,clk,rst;
  output reg q;

  always @(posedge clk)
     begin:dff_block
        if(rst==1'b1)
          q=1'b0;
        else
          q=d;
     end
  endmodule