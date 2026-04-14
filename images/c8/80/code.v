module counter
  (input clk, input reset,
   output reg [3:0] count);

   always @(posedge clk)
     if(reset)
       count <= 4'd0;
     else if(count == 4'd9)
       count <= 4'd0;
     else
       count <= count + 4'd1;
   
endmodule