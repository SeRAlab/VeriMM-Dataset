module top_module(
  input wire [7:0] a,
  input wire [7:0] b,
  output reg [15:0] p // Change output to reg
);reg [15:0] A;
  reg [2:0] q0;
  reg [15:0] a_shifted; // Change to match the width of A
  integer i;

  always @(*) begin
    A = 0;
    q0 = b[2:0]; // Correct part select from b[0:2] to b[2:0]
    a_shifted = {a, 1'b0}; 
    for (i = 0; i < 8; i = i + 1) begin
      case(q0)
        3'b001: A = A + a_shifted;
        3'b010: A = A - a_shifted;
        3'b011: A = A + (a_shifted << 1);
        3'b100: A = A - (a_shifted << 1);
      endcase
      A = A >> 1;
      q0 = {A[0], q0[2:1]};
    end
    p = A; // Direct assignment to p since p is now a reg
  end

endmodule