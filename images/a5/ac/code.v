module top_module(out,in,ld,clk,clr);input [15:0] in;
    input ld,clk,clr;
    output reg [15:0] out;
    always@(posedge clk)
      if (clr)
        out <= 0;
    else if(ld)
        out <= in;endmodule