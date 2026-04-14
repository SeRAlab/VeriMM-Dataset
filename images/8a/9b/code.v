module top_module(
  input rstn,
  input clk,
  output reg rst
);parameter t_hold = 2; // reset hold time (in clock cycles)
parameter t_setup = 2; // reset setup time (in clock cycles)

reg [1:0] rst_sync; // synchronized reset signal
reg [1:0] rst_delay; // delayed reset signal

always @(posedge clk) begin
  rst_delay <= {rst_delay[0], rstn}; // delay the reset signal by one clock cycle
  if (rst_delay[1] == 1'b0) begin // if the delayed reset signal is low
    rst_sync <= {rst_sync[0], 1'b0}; // hold the synchronized reset signal low
  end else if (rst_delay[0] == 1'b1) begin // if the delayed reset signal is high
    rst_sync <= {rst_sync[0], 1'b1}; // set the synchronized reset signal high
  end
end

assign rst = rst_sync[1]; // output the synchronized reset signal

initial begin
  rst_sync = 2'b11; // initialize the synchronized reset signal to high
  rst_delay = 2'b11; // initialize the delayed reset signal to high
end

endmodule