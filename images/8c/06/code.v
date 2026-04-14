module top_module(/*AUTOARG*/
   input clk,
   input reset,
   input [7:0] data_in,
   output reg [7:0] data_out
   );wire [7:0] intermediate_wire;
   reg [7:0] intermediate_reg;

   assign intermediate_wire = data_in + 8'h5;

   always @(posedge clk or posedge reset) begin
      if (reset) begin
         data_out <= 8'h0;
      end else begin
         intermediate_reg <= intermediate_wire;
         data_out <= intermediate_reg - 8'h1;
      end
   end

endmodule