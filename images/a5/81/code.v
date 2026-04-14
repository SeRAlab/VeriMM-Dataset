module top_module(
  input clk,        // clock input
  input reset,      // reset input
  input load,       // load input
  input [3:0] target,  // target value input
  output reg [3:0] count,  // binary count output
  output reg equal  // target value equality output
);always @(posedge clk) begin
    if (reset) begin
      count <= 4'b0000;
    end else if (load) begin
      count <= target;
    end else begin
      count <= count + 1;
    end
  end
  
  always @(*) begin
    if (count == target) begin
      equal = 1;
    end else begin
      equal = 0;
    end
  end

endmodule