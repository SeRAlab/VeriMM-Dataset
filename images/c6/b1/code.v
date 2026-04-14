module adder_subtractor(
  input [3:0] A,
  input [3:0] B,
  input SUB,
  output reg [3:0] out
);

  always @(*) begin
    if(SUB) begin
      out <= A - B;
    end else begin
      out <= A + B;
    end
  end

endmodule