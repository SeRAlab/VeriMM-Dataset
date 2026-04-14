module top_module(
  input [n-1:0] in,
  input clk,
  input rst,
  output reg out,
  output reg done
);parameter n = 8; // number of digital inputs
parameter rmax = 100; // maximum resistance
parameter rstep = 1; // resistance step size
parameter steps = rmax / rstep; // total number of steps

reg [n-1:0] count; // counter to keep track of the current step
reg [7:0] resistance; // current resistance value

always @(posedge clk) begin
  if (rst) begin
    count <= 0;
    resistance <= 0;
    out <= 0;
    done <= 0;
  end else begin
    // update the count based on the input signals
    count <= in;
    
    // compute the resistance based on the current step
    resistance <= count * rstep;
    
    // update the analog output
    out <= resistance;
    
    // set the done signal high when the potentiometer has finished adjusting its resistance
    if (count == steps) begin
      done <= 1;
    end else begin
      done <= 0;
    end
  end
end

endmodule