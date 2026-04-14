module add_sub_overflow (
  input clk,
  input reset,
  input [3:0] A,
  input [3:0] B,
  input Add,
  input Sub,
  output [3:0] O,
  output V
);

reg [4:0] temp;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    temp <= 0;
    V <= 0;
  end else begin
    if (Add) begin
      temp <= A + B;
      V <= (temp > 15);
    end else if (Sub) begin
      temp <= A - B;
      V <= (temp < 0);
    end
  end
end

assign O = temp[3:0];

endmodule
