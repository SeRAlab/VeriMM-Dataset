module top_module(
   input clk,
   input [7:0] A,
   input [7:0] B,
   output reg [15:0] C
);reg [7:0] A_delayed;
reg [7:0] B_delayed;
reg [15:0] C_delayed;

always @(posedge clk) begin
   A_delayed <= A;
   B_delayed <= B;
   C_delayed <= A + B;
end

always @(posedge clk) begin
   if (A == A_delayed && B == B_delayed) begin
      C <= C_delayed;
   end
   else begin
      C <= A + B;
   end
end

endmodule