module top_module(
  input  wire           clk,
  input  wire           rst,
  output reg  [4-1:0]   count
);always @(posedge clk or negedge rst) begin
  if (~rst) begin
    count <= #1 4'b0;
  end
  else begin
    count <= #1 count + 1;
  end
end

endmodule