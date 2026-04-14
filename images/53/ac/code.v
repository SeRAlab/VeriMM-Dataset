module top_module(
    input wire clk,
    input wire [7:0] i,
    input wire a,
    output reg [7:0] o
);reg cond = 0;

   always @(posedge clk) begin
     if (cond) o = i;
     cond = a;
     if (cond) o = ~i;
   end

endmodule