module top_module(/*AUTOARG*/
   // Inputs
   clk
   );input clk;

   wire  a = clk;
   wire  b = 1'b0;
   reg   c;

   // Commenting out the test module instantiation as it is missing
   // test test_i (/*AUTOINST*/
   //         // Inputs
   //         .clk			(clk));

   reg [1:0] counter = 2'b00;

   always @(posedge clk) begin
      if (counter == 2'b11) begin
         counter <= 2'b00;
      end
      else begin
         counter <= counter + 1;
      end
   end

   assign c = counter;

endmodule