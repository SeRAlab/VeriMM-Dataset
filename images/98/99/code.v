module shift_register_8bit (clk, rst, data_in, q);
   input clk, rst, data_in;
   output reg [7:0] q;
   
   always @(posedge clk) begin
      if (rst)
         q <= 8'b00000000;
      else
         q <= {q[6:0], data_in};
   end
endmodule