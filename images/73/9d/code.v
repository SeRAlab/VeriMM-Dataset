module top_module(
  input clk, // clock signal
  input rst, // reset signal
  output reg wd // watchdog signal
);parameter t = 100; // timeout value in clock cycles

reg [7:0] count; // counter to keep track of clock cycles

always @(posedge clk) begin
  if (rst) begin
    count <= 0;
    wd <= 0;
  end else begin
    count <= count + 1;
    if (count >= t) begin
      wd <= 0;
    end else begin
      wd <= 1;
    end
  end
end

endmodule