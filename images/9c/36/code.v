module down_counter (
  input clk,
  input reset,
  output reg [9:0] count);always @(posedge clk) begin
    if (reset) count <= 10'b1111111111;
    else count <= count - 1;
end

endmodule