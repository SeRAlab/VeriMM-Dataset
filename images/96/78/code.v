module top_module(
  input  wire        clk,    // clock signal
  input  wire        reset,  // synchronous reset signal
  output reg  [3:0]  count   // 4-bit count output
);always @(posedge clk) begin
    if (reset) begin
      count <= 4'b0000; // reset count to 0
    end else begin
      count <= count + 1; // increment count
    end
  end

endmodule