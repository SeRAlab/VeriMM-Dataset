module shift_register (clk, rst_n, load_n, parallel_in, q);
   input clk, rst_n, load_n;
   input [7:0] parallel_in;
   output reg [7:0] q;

   always @(posedge clk or negedge rst_n) begin
      if (!rst_n)
         q <= 8'b00000000;
      else if (!load_n)
         q <= parallel_in;
      else
         q <= {q[6:0], 1'b0};
   end
endmodule