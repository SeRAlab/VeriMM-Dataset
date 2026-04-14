module top_module(
  input [3:0] A,
  input [3:0] B,
  input CLK,
  input RST,
  output [4:0] C,
  output OV
);reg [4:0] C_reg;
  wire [4:0] C_next;
  wire OV_next;

  always @(posedge CLK, negedge RST) begin
    if (!RST) begin
      C_reg <= 5'b0;
    end else begin
      C_reg <= C_next;
    end
  end

  assign C = C_reg;
  assign OV = OV_next;

  assign C_next[0] = A[0] ^ B[0];
  assign C_next[1] = A[1] ^ B[1] ^ C_reg[0];
  assign C_next[2] = A[2] ^ B[2] ^ C_reg[1];
  assign C_next[3] = A[3] ^ B[3] ^ C_reg[2];
  assign C_next[4] = A[3] & B[3] | A[2] & B[2] | A[1] & B[1] | A[0] & B[0] | C_reg[3] & (A[3] | B[3] | A[2] | B[2] | A[1] | B[1] | A[0] | B[0]);

  assign OV_next = C_next[4];

endmodule