module parallel_load_register_8bit (data_out, clk, reset, en, load, data_in);
   input clk, reset, en, load;
   input [7:0] data_in;
   output [7:0] data_out;
   
   reg [7:0] data_out;
   
   always @(posedge clk or posedge reset) begin
      if (reset)
         data_out <= 8'b0;
      else if (en) begin
         if (load)
            data_out <= data_in;
      end
   end
   
endmodule