module top_module(/*AUTOARG*/
   // Inputs
   clk,
   // Outputs
   gray_out
   );input clk;
   output reg [3:0] gray_out;

   reg [1:0] state;

   always @(posedge clk) begin
      case(state)
         2'b00: begin
            gray_out <= 4'b0000;
            state <= 2'b01;
         end
         2'b01: begin
            gray_out <= 4'b0001;
            state <= 2'b10;
         end
         2'b10: begin
            gray_out <= 4'b0011;
            state <= 2'b11;
         end
         2'b11: begin
            gray_out <= 4'b0010;
            state <= 2'b10;
         end
      endcase
   end
endmodule