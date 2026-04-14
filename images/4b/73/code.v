module shift_register (clk, rst_n, din, dout);
   input clk, rst_n, din;
   output reg [7:0] dout;

   always @(posedge clk or negedge rst_n) begin
      if (!rst_n)
         dout <= 8'b00000000;
      else
         dout <= {dout[6:0], din};
   end
endmodule