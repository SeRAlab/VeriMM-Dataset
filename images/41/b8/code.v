module shift_register_3bit (clk, rst, load, data_in, serial_in, q);
   input clk, rst, load;
   input [2:0] data_in;
   input serial_in;
   output reg [2:0] q;
   
   always @(posedge clk) begin
      if (rst)
         q <= 3'b000;
      else if (load)
         q <= data_in;
      else
         q <= {serial_in, q[2:1]};
   end
endmodule