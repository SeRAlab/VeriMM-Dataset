module adder_subtractor (
  input [3:0] A,
  input [3:0] B,
  input opcode,
  output reg [3:0] sum
);

  always @(*) begin
    if (opcode == 0) begin
      sum = A + B;
    end else begin
      sum = A - B;
    end
  end

endmodule
