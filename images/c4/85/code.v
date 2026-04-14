module adder (
  input [7:0] A,
  input [7:0] B,
  input EN,
  output [7:0] SUM,
  output OVF
);

  reg [8:0] temp_sum;
  reg [7:0] prev_A;
  reg [7:0] prev_B;
  reg prev_EN;

  always @(*) begin
    if (EN == 1'b1) begin
      temp_sum = A + B;
      if ((A[7] == B[7]) && (A[7] != temp_sum[7]))
        OVF = 1'b1;
      else
        OVF = 1'b0;
    end
    else begin
      temp_sum = {prev_A, prev_B} + prev_EN;
    end
  end

  always @(posedge EN) begin
    if (EN == 1'b1) begin
      prev_A = A;
      prev_B = B;
      prev_EN = EN;
    end
  end

  assign SUM = temp_sum[7:0];

endmodule