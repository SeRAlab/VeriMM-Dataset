module sum4bits(
  input [3:0] A,
  input [3:0] B,
  output [3:0] SUM
);

  assign SUM = A + B;

  always @*
  begin
    if (SUM > 15)
    begin
      $display("Error: Sum is greater than 15");
    end
  end

endmodule