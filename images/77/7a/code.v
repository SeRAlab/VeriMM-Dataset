module register_16bit (clk, rst, en, data_in, q);
   input clk, rst, en;
   input [15:0] data_in;
   output reg [15:0] q;
   
   always @(posedge clk) begin
      if (rst)
         q <= 16'b0000000000000000;
      else if (en)
         q <= data_in;
   end
endmodule