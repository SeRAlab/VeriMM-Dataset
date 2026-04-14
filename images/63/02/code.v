module priority_encoder_4to2 (a, y);
   input [3:0] a;
   output reg [1:0] y;

   always @(a) begin
      if (a[3])
         y = 2'b11;
      else if (a[2])
         y = 2'b10;
      else if (a[1])
         y = 2'b01;
      else if (a[0])
         y = 2'b00;
      else
         y = 2'b00; // Default case if no input is set
   end
endmodule