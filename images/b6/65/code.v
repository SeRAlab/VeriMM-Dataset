module top_module(
  input [7:0] A,
  input [7:0] B,
  input [7:0] C,
  input [7:0] D,
  input [7:0] E,
  input [7:0] F,
  input [7:0] G,
  input [7:0] H,
  output reg [1:0] F_out
);reg [7:0] nand1;
reg [7:0] nand2;
reg [7:0] nand3;
reg [7:0] nand4;
reg [7:0] nand5;
reg [7:0] nand6;
reg [7:0] nand7;

// First NAND gate
assign nand1 = ~(A & B);

// Second NAND gate
assign nand2 = ~(C & D);

// Third NAND gate
assign nand3 = ~(E & F);

// Fourth NAND gate
assign nand4 = ~(G & H);

// Fifth NAND gate
assign nand5 = ~(nand1 & nand2);

// Sixth NAND gate
assign nand6 = ~(nand3 & nand4);

// Final NAND gate
assign F_out = ~(nand5 & nand6);

endmodule