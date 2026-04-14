module adder_subtractor(
  input [3:0] A,
  input [3:0] B,
  input SUB,
  output reg [3:0] S,
  output reg OVF
);

  reg [3:0] B_neg;
  reg C_in;
  
  always @ (A or B or SUB) begin
    if (SUB == 1) begin
      B_neg = ~B + 1;
    end else begin
      B_neg = B;
    end
  end
  
  always @ (A or B or SUB) begin
    C_in = SUB & (A < B_neg);
  end
  
  always @ (A or B or SUB) begin
    if (SUB == 1) begin
      S = A - B_neg;
    end else begin
      S = A + B;
    end
  end
  
  always @ (A or B or SUB) begin
    OVF = C_in ^ (S[3] ^ A[3]);
  end
  
endmodule