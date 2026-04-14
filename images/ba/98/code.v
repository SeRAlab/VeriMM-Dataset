module top_module(
  // inputs:
  clk,
  reset,
  
  // outputs:
  count
);// inputs
  input clk;
  input reset;
  
  // outputs
  output reg [3:0] count;

  // counter logic
  always @(posedge clk, negedge reset) begin
    if (!reset) begin
      count <= 4'b0;
    end else begin
      count <= count + 1;
    end
  end

endmodule