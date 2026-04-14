module top_module(
   input wire clk,
   input wire reset,
   input wire [3:0] in1,
   input wire [3:0] in2,
   input wire cin,
   output reg [3:0] out,
   output reg cout);always @(posedge clk) begin
      if (reset) begin
         out <= 4'b0000;
         cout <= 1'b0;
      end else begin
         out <= in1 + in2 + cin;
         if (out > 4'hf) begin
            cout <= 1'b1;
         end else begin
            cout <= 1'b0;
         end
      end
   end

endmodule