module top_module(
   input clk,
   input reset,
   output reg [1:0] light
);parameter GREEN_CYCLES = 10;
   parameter YELLOW_CYCLES = 2;
   parameter RED_CYCLES = 8;

   reg [3:0] count;

   always @(posedge clk or negedge reset) begin
      if(!reset) begin
         count <= 0;
         light <= 2'b10; // start with red light
      end
      else begin
         if(count == GREEN_CYCLES + YELLOW_CYCLES + RED_CYCLES - 1) begin
            count <= 0;
            light <= 2'b00; // switch to green light
         end
         else if(count == GREEN_CYCLES + YELLOW_CYCLES - 1) begin
            count <= count + 1;
            light <= 2'b01; // switch to yellow light
         end
         else if(count == GREEN_CYCLES - 1) begin
            count <= count + 1;
            light <= 2'b10; // switch to red light
         end
         else begin
            count <= count + 1;
         end
      end
   end

endmodule