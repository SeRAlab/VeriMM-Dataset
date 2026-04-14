module top_module(
  input [31:0] A,
  input [31:0] B,
  output reg [63:0] Y  // Change 'output' to 'output reg'
);reg signed [63:0] signed_A;
  reg signed [63:0] signed_B;
  reg signed [63:0] signed_Y;

  always @(*) begin
    if (A[31] == 1) begin
      signed_A = {32'b11111111_11111111_11111111_11111111, A};
    end else begin
      signed_A = {32'b00000000_00000000_00000000_00000000, A};
    end

    if (B[31] == 1) begin
      signed_B = {32'b11111111_11111111_11111111_11111111, B};
    end else begin
      signed_B = {32'b00000000_00000000_00000000_00000000, B};
    end

    signed_Y = signed_A * signed_B;

    if (A[31] == 1 && B[31] == 1) begin
      Y = signed_Y[63:0];
    end else if (A[31] == 0 && B[31] == 0) begin
      Y = signed_Y[31:0]; // This may be incorrect logic for unsigned multiplication
    end else begin
      Y = signed_Y[63:0];
    end
  end

endmodule