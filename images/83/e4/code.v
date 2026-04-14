module top_module(
  input clk,
  input reset,
  input enable,
  output reg [3:0] count
);reg [3:0] next_count;
  
  always @(posedge clk) begin
    if (reset) begin
      count <= 4'b0;
    end else if (enable) begin
      count <= next_count;
    end
  end
  
  always @(*) begin
    if (reset) begin
      next_count = 4'b0;
    end else begin
      next_count = count + 1;
    end
  end
  
endmodule