module register_16bit (reg_out, clk, reset, en, data_in);
   input clk, reset, en;
   input [15:0] data_in;
   output [15:0] reg_out;
   
   reg [15:0] reg_out;
   
   always @(posedge clk or posedge reset) begin
      if (reset)
         reg_out <= 16'b0;
      else if (en)
         reg_out <= data_in;
   end
   
endmodule