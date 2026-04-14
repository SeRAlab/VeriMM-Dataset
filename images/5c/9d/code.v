module top_module(
  input clk_in, 
  input rst,
  output reg clk_out
);parameter div_factor = 2;
integer count = 0; // counter to track number of clock cycles

always @(posedge clk_in or posedge rst) begin
  if (rst) begin
    clk_out <= 0;
    count <= 0;
  end else begin
    if (count == (div_factor - 1)) begin
      clk_out <= ~clk_out; // toggle the output clock signal
      count <= 0;          // reset counter
    end else begin
      count <= count + 1;  // increment counter
    end
  end
end

endmodule