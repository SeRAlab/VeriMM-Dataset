module top_module(
  input trig,
  input clk,
  input rst,
  output reg out // Change output to reg type
);parameter t = 10; // duration of output pulse in clock cycles
  
  reg [31:0] count = 0;
  reg pulse = 0;
  
  always @(posedge clk) begin
    if (rst) begin
      count <= 0;
      pulse <= 0;
      out <= 0;
    end
    else if (trig && !pulse) begin
      count <= 0;
      pulse <= 1;
      out <= 1;
    end
    else if (pulse && count < t-1) begin
      count <= count + 1;
      out <= 1;
    end
    else if (pulse && count == t-1) begin
      count <= 0;
      pulse <= 0;
      out <= 0;
    end
    else begin
      out <= 0;
    end
  end
  
endmodule