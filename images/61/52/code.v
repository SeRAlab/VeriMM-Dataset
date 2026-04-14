module top_module( out, out2, in );input      [9:0] in;
   output reg [3:0] out;
   output reg [3:0] out2;

    

   always @* begin
      casez (in)
      10'b0000000000 : out = 4'h0;
      10'b?????????1 : out = 4'h0;
      10'b????????10 : out = 4'h1;
      10'b???????100 : out = 4'h2;
      10'b??????1000 : out = 4'h3;
      10'b?????10000 : out = 4'h4;
      10'b????100000 : out = 4'h5;
      10'b???1000000 : out = 4'h6;
      10'b??10000000 : out = 4'h7;
      10'b?100000000 : out = 4'h8;
      10'b1000000000 : out = 4'h9;
      endcase
   end

   
   
   

   always @* begin
      casez (in)
      10'b0000000000 : out2 = 4'h0;
      10'b?????????1 : out2 = 4'h0;
      10'b????????10 : out2 = 4'h1;
      10'b???????100 : out2 = 4'h2;
      10'b??????1000 : out2 = 4'h3;
      10'b?????10000 :  ;
      10'b????100000 : out2 = 4'h5;
      10'b???1000000 : out2 = 4'h6;
      10'b??10000000 : out2 = 4'h7;
      10'b?100000000 : out2 = 4'h8;
      10'b1000000000 : out2 = 4'h9;
      endcase
   end

endmodule