module top_module(output reg Z, input [3:0] A, input [1:0] S);wire [1:0] not_S;
  assign not_S = ~S;

  wire [3:0] sel1, sel2;
  assign sel1 = A & {2'b11, not_S[1]} & {2{not_S[0]}}; // Correct for 4-bit selection
  assign sel2 = A & {2'b11, not_S[0]} & {2{not_S[1]}}; // Correct for 4-bit selection

  always @(*) begin
    case (S)
      2'b00: Z = A[0];          // Select A[0]
      2'b01: Z = A[1];          // Select A[1]
      2'b10: Z = A[2];          // Select A[2]
      2'b11: Z = A[3];          // Select A[3]
      default: Z = 1'b0;        // Default case (optional)
    endcase
  end

endmodule