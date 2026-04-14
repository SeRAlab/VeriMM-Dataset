module counter (
  input clk,
  input en,
  output reg [7:0] count);always @(posedge clk) begin
    if (en)
        count <= count + 1;
end
endmodule