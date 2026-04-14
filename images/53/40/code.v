module shift_register_8bit (clk, rst, en, data_in, q);
   input clk, rst, en, data_in;
   output reg [7:0] q;
   
   always @(posedge clk or posedge rst) begin
      if (rst)
         q <= 8'b00000000;
      else if (en)
         q <= {q[6:0], data_in};
   end
endmodule