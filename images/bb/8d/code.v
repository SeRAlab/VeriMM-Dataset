module top_module(
  output reg [3:0] count,
  input clk,
  input reset
);always @(posedge clk or negedge reset) begin
    if(!reset) begin
      count <= 4'b0;
    end else begin
      count <= count + 1;
    end
  end

endmodule