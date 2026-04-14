module top_module(
  input clk,
  input data,
  output delayed_data
);parameter DELAY = 1;
  reg [DELAY-1:0] data_buffer;
  reg [DELAY-1:0] delayed_data_buffer;
  reg [DELAY-1:0] delay_counter;

  always @(posedge clk) begin
    delay_counter <= delay_counter + 1;
    if (delay_counter == DELAY) begin
      delayed_data_buffer <= data_buffer;
    end
    data_buffer <= data;
  end

  assign delayed_data = delayed_data_buffer[DELAY-1];

endmodule