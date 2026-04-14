module top_module(clk, reset, load, data_in, shift, data_out);parameter width = 8;
   
   input clk;
   input reset;
   input load;
   input shift;
   input [width-1:0] data_in;
   output [width-1:0] data_out;
   
   reg [width-1:0] reg_data;
   
   always @(posedge clk) begin
      if (reset) begin
         reg_data <= 0;
      end
      else begin
         if (load) begin
            reg_data <= data_in;
         end
         else if (shift) begin
            reg_data <= {reg_data[width-2:0], shift ? 1'b0 : reg_data[width-1]};
         end
      end
   end
   
   assign data_out = reg_data;
   
endmodule