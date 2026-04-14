module top_module(/*AUTOARG*/
   // Inputs
   clk,
   reset,
   in,
   // Outputs
   out
   );input clk, reset, in;
   output reg out; // Changed from wire to reg

   reg [3:0] shift_reg;
   reg [1:0] state;
   parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

   always @ (posedge clk or posedge reset) begin
      if (reset) begin
         shift_reg <= 4'b0;
         state <= S0;
         out <= 1'b0;
      end
      else begin
         shift_reg <= {shift_reg[2:0], in};
         case (state)
            S0: begin
               if (shift_reg == 4'b1011) begin
                  state <= S1;
               end
            end
            S1: begin
               state <= S2;
            end
            S2: begin
               state <= S3;
            end
            S3: begin
               state <= S0;
               out <= 1'b1;
            end
         endcase
      end
   end

endmodule