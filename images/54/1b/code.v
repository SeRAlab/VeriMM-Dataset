module top_module(
  input clk,
  input [5:0] x_os,
  input [5:0] y_os,
  output reg [11:0] x_os_integ,
  output reg [11:0] y_os_integ
);reg [5:0] x_os_prev = 6'h00;
  reg [5:0] y_os_prev = 6'h00;
  reg [1:0] counter = 2'b00;

  always @(posedge clk) begin
    // Update previous values of x_os and y_os
    x_os_prev <= x_os;
    y_os_prev <= y_os;

    // Integration period set to 3 clock cycles
    if (counter == 2'b11) begin
      x_os_integ <= x_os_integ + {{6{x_os_prev[5]}}, {x_os_prev[5:0]}};
      y_os_integ <= y_os_integ + {{6{y_os_prev[5]}}, {y_os_prev[5:0]}};
      counter <= 2'b00;
    end
    else begin
      counter <= counter + 1;
    end
  end

endmodule