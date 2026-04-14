module reg_32bit (data_out, clk, reset, en, data_in);
   input clk, reset, en;
   input [31:0] data_in;
   output [31:0] data_out;
   
   reg [31:0] data_out;
   
   always @(posedge clk or posedge reset) begin
      if (reset)
         data_out <= 32'b0;
      else if (en)
         data_out <= data_in;
   end
   
endmodule