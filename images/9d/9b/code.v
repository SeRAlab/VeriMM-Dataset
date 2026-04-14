module top_module(
  input clk, // clock signal
  input cen, // count enable signal (active high)
  input dir, // direction signal (0 for count up, 1 for count down)
  input rst, // reset signal (active high)
  output reg [n-1:0] out // output signals
);parameter n = 4; // number of bits in the counter
parameter start_value = 4; // starting value of the counter

reg [n-1:0] count; // register to hold the current count value

always @(posedge clk) begin
  if (rst) begin // reset the counter to the starting value
    count <= start_value;
  end else if (cen) begin // only count if the count enable signal is high
    if (dir == 0) begin // count up
      count <= count + 1;
    end else begin // count down
      count <= count - 1;
    end
  end
end

assign out = count; // output the current count value

endmodule