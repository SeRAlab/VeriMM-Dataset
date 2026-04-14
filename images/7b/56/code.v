module top_module (
  input clk,
  input reset,
  input enable,
  input d,
  output reg q);
  
always @(posedge clk or posedge reset) begin
    if (reset)
        q <= 1'b0;
    else if (enable)
        q <= d;
end
endmodule