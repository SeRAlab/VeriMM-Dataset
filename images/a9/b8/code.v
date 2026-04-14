module top_module(
  input clk,
  input [width-1:0] D,
  input [width-1:0] J,
  input [width-1:0] K,
  input [width-1:0] S,
  input [width-1:0] R,   // Added input R for SR flip-flop
  input [width-1:0] T,   // Added input T for T flip-flop
  output reg [width-1:0] QD,
  output reg [width-1:0] QJK,
  output reg [width-1:0] QT,
  output reg [width-1:0] QSR
);parameter width = 1; // width of the flip-flop

reg [width-1:0] D_ff;
reg [width-1:0] JK_ff;
reg [width-1:0] T_ff;
reg [width-1:0] SR_ff;

always @(posedge clk) begin
  D_ff <= D; // D flip-flop
  JK_ff <= (J & ~K) | (JK_ff & (~J & K)); // JK flip-flop behavior
  T_ff <= T ^ QJK; // T flip-flop behavior; use QJK as it is the output of JK_ff
  SR_ff <= (~S & SR_ff) | (S & ~R) | (S & R & ~SR_ff); // SR flip-flop behavior
end

assign QD = D_ff;
assign QJK = JK_ff;
assign QT = T_ff;
assign QSR = SR_ff;

endmodule