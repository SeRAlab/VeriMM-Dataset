module top_module(
  input start,
  input stop,
  input clk,
  output reg [n-1:0] out
);parameter n = 8; // number of bits used to represent the time interval
parameter resolution = 1; // resolution of the output, in clock cycles. Eg. 1 for 1 clock cycle, 2 for 2 clock cycles, etc.

reg [n-1:0] count; // counter to keep track of clock cycles
reg counting; // flag to indicate whether we are counting or not

always @(posedge clk) begin
  if (start) begin
    counting <= 1;
    count <= 0;
  end else if (stop) begin
    counting <= 0;
  end
  
  if (counting) begin
    count <= count + 1;
  end
end

always @(posedge clk) begin
  if (stop) begin
    out <= count >> resolution; // shift count right by resolution bits to get the output
  end
end

endmodule