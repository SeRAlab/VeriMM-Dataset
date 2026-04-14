module top_module(
  input clk,
  input rst,
  input [31:0] delay_cycles,
  input [31:0] data_in,
  output [31:0] data_out
);parameter DELAY_WIDTH = 32; // Width of delay line
  parameter [31:0] DELAY_INIT = 0; // Initial value for delay line
  parameter DELAY_TYPE = "VARIABLE"; // Type of delay line

  reg [DELAY_WIDTH-1:0] delay_line [0:DELAY_WIDTH-1];
  reg [31:0] current_data;

  integer i;

  always @(posedge clk) begin
    if (rst) begin
      current_data <= 0;
      for (i = 0; i < DELAY_WIDTH; i = i + 1) begin
        delay_line[i] <= DELAY_INIT;
      end
    end else begin
      current_data <= data_in;
      for (i = 0; i < DELAY_WIDTH-1; i = i + 1) begin
        delay_line[i] <= delay_line[i+1];
      end
      delay_line[DELAY_WIDTH-1] <= current_data;
    end
  end

  assign data_out = delay_line[delay_cycles];

endmodule