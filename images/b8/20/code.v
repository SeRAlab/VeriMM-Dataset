module register_16bit (clk, en, data_in, q);
   input clk, en;
   input [15:0] data_in;
   output reg [15:0] q;
   
   always @(posedge clk) begin
      if (en)
         q <= data_in;
   end
endmodule