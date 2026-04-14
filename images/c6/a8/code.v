module add_sub_4bit (
  input [3:0] num1,
  input [3:0] num2,
  input sub,
  output reg [3:0] result
);

  always @(*) begin
    if (sub) begin
      result <= num1 - num2;
    end else begin
      result <= num1 + num2;
    end
  end
  
endmodule
