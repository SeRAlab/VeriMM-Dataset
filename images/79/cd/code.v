module top_module(X,
    D,
    B,
    C,
    SEL,
    A);output reg [7:0] X; // Change output to reg type for always block
  input [7:0] D;
  input [7:0] B;
  input [7:0] C;
  input [1:0] SEL;
  input [7:0] A;

  always @* begin
    case (SEL)
      2'b00: X = D;  // Select D when SEL is 00
      2'b01: X = B;  // Select B when SEL is 01
      2'b10: X = C;  // Select C when SEL is 10
      2'b11: X = A;  // Select A when SEL is 11
      default: X = 8'b0; // Default case
    endcase
  end
endmodule