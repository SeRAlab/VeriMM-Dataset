module down_counter_12bit (clk, rst, en, q);
   input clk, rst, en;
   output reg [11:0] q;
   
   always @(posedge clk) begin
      if (rst)
         q <= 12'b000000000000;
      else if (en)
         q <= q - 1;
   end
endmodule