module register_32bit (clk, rst, en, data_in, q);
   input clk, rst, en;
   input [31:0] data_in;
   output reg [31:0] q;
   
   always @(posedge clk) begin
      if (rst)
         q <= 32'b00000000000000000000000000000000;
      else if (en)
         q <= data_in;
   end
endmodule