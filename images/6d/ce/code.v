module top_module(
   input clock0,
   input clock180,
   input reset,

   input [1:0] rotary,

   output reg [7:0] leds
);always @(posedge clock0) begin
      if (reset) begin
         leds <= 8'b00000000;
      end else begin
         case (rotary)
            2'b00: leds <= 8'b00000000;
            2'b01: begin
               if (leds == 8'b11111111) begin
                  leds <= 8'b00000000;
               end else begin
                  leds <= leds + 1;
               end
            end
            2'b10: begin
               if (leds == 8'b00000000) begin
                  leds <= 8'b11111111;
               end else begin
                  leds <= leds - 1;
               end
            end
         endcase
      end
   end

endmodule