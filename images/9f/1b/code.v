module top_module(
  input clk,
  input reset,
  input [3:0] A,
  input [3:0] B,
  input Add,
  input Sub,
  output reg [3:0] O, // Changed to reg to allow assignment in always block
  output reg V        // Changed to reg to allow assignment in always block
);reg [4:0] temp;

always @(posedge clk or posedge reset) begin
  if (reset) begin
    temp <= 0;
    V <= 0;
    O <= 0;
  end else begin
    if (Add) begin
      temp <= A + B;
      V <= (temp > 15);
    end else if (Sub) begin
      temp <= A - B;
      V <= (temp < 0);
    end
    O <= temp[3:0]; // Moved assignment of O here to ensure it's updated in the always block
  end
end

endmodule