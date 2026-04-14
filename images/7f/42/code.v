module top_module(
  input [3:0] Q, // Asynchronous input signal
  input clk, // Input clock
  input rst, // Asynchronous reset signal
  output reg [3:0] D, // Synchronous output signal
  input rst_sync // Synchronous reset signal
);reg [3:0] Q_sync; // Synchronized input signal

  // Synchronize input signal
  always @(posedge clk) begin
    if (rst) begin
      Q_sync <= 4'b0;
    end else begin
      Q_sync <= Q;
    end
  end

  // Output synchronized signal
  always @(posedge clk) begin
    if (rst_sync) begin
      D <= 4'b0;
    end else begin
      D <= Q_sync;
    end
  end

endmodule