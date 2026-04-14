module top_module(clk, input_value, output_value);input clk;
   input [3:0] input_value;
   output [3:0] output_value;

   reg [3:0] ones_complement;
   reg [3:0] twos_complement;

   assign output_value = twos_complement;

   always @(posedge clk)
     begin
       ones_complement <= ~input_value;
       twos_complement <= ones_complement + 4'b1;
     end
endmodule