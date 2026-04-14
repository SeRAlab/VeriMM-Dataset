module top_module(
  input clk,
  input reset,
  input [3:0] in1,
  input [3:0] in2,
  input mode_sel,
  output [3:0] out
);reg [3:0] temp;

always @(posedge clk, negedge reset) begin
  if (!reset) begin
    temp <= 4'b0;
  end else begin
    if (mode_sel == 0) begin
      temp <= in1 + in2;
    end else begin
      temp <= in1 - in2;
    end
  end
end

assign out = temp;

endmodule