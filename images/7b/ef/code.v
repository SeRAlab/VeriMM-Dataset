module top_module(
  input data_in,
  input clk_in,
  input clk_out,
  output reg data_out
);reg [1:0] data_ff;
  reg [1:0] pulse_ff;
  reg [1:0] pulse_sync;
  reg [1:0] pulse_delay;

  always @(posedge clk_in) begin
    data_ff <= {data_in, data_ff[1]};
    pulse_ff <= {data_in ^ data_ff[1], pulse_ff[1]};
  end

  always @(posedge clk_out) begin
    pulse_sync <= pulse_ff ^ pulse_delay;
    pulse_delay <= pulse_sync;
    data_out <= data_ff[1];
  end

endmodule