module top_module(clk, cken_in, cken_out, decimrate, reset, din, dout);input [11:0]    din;
   input [2:0]     decimrate;      
   output [19:0]   dout;
   reg [19:0]      dout;
   input           clk, cken_in, reset;
   output          cken_out;
   reg             cken_out;       
   reg [35:0]      i0, i1, i2, i3, i4, i5, i6, i7;
   reg [35:0]      d0, d1, d2, d3, d4, d5, d6, d7;
   reg [2:0]       decimcount; 
   always @(posedge clk)
     if(reset == 1'b1)
       decimcount <= 0;
     else if(cken_in == 1'b1)
       begin
          
          i0 = i0 + {{24{din[11]}}, din};
          i1 = i1 + i0;
          i2 = i2 + i1;
          i3 = i3 + i2;
          i4 = i4 + i3;
          i5 = i5 + i4;
          i6 = i6 + i5;
          i7 = i7 + i6;
          
          if(decimcount == 0)
            begin
               decimcount <= decimrate;
               cken_out <= 1'b1;
               
               d0 <= i7 - d0;
               d1 <= d0 - d1;
               d2 <= d1 - d2;
               d3 <= d2 - d3;
               d4 <= d3 - d4;
               d5 <= d4 - d5;
               d6 <= d5 - d6;
               d7 <= d6 - d7;
               
               if(decimrate[2] == 1'b1)
                 dout <= d7[35:16];
               else if(decimrate[1] == 1'b1)
                 dout <= d7[27:8];
               else
                 dout <= d7[19:0];
            end 
          else
            begin
               decimcount = decimcount - 1;
               cken_out <= 1'b0;
            end 
       end 
endmodule