module up_down_counter (
  input clk,
  input reset,
  input enable,
  input up_down,
  output reg [2:0] count);always @(posedge clk) begin
    if (reset) count <= 3'b000;
    else if (enable) count <= up_down ? count + 1 : count - 1;
end

endmodule