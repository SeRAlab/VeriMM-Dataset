module top_module(
    input [3:0] A,
    input [3:0] B,
    input CLK,
    output [4:0] S
);reg [0:0] Q1, Q2, Q3, Q4;
  reg [0:0] ready_add_subt1, ready_add_subt2, ready_add_subt3, ready_add_subt4;

  always @(posedge CLK) begin
      Q1 <= A[0] ^ B[0];
      Q2 <= A[1] ^ B[1] ^ Q1[0];
      Q3 <= A[2] ^ B[2] ^ Q2[0];
      Q4 <= A[3] ^ B[3] ^ Q3[0];
  end

  assign S[0] = Q1[0];
  assign S[1] = Q2[0];
  assign S[2] = Q3[0];
  assign S[3] = Q4[0];

  assign ready_add_subt1 = 1'b1;
  assign ready_add_subt2 = ready_add_subt1;
  assign ready_add_subt3 = ready_add_subt2;
  assign ready_add_subt4 = ready_add_subt3;

  assign S[4] = Q4[0];  // Carry out

endmodule