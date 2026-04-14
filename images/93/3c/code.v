module up_counter (
  input clk,
  input reset,
  input load,
  input [3:0] d,
  output reg [3:0] count);always @(posedge clk) begin
    if (reset)
        count <= 4'b0000;
    else if (load)
        count <= d;
    else
        count <= count + 1;
end
endmodule