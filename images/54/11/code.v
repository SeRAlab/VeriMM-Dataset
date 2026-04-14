module counter_8bit (counter_out, clk, reset, en, load, load_value);
   input clk, reset, en, load;
   input [7:0] load_value;
   output [7:0] counter_out;
   
   reg [7:0] counter_out;
   
   always @(posedge clk or posedge reset) begin
      if (reset)
         counter_out <= 8'b0;
      else if (load)
         counter_out <= load_value;
      else if (en)
         counter_out <= counter_out + 1;
   end
   
endmodule