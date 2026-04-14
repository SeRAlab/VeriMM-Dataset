module top_module(
  input clk,
  input state_we_in,
  input state_re_in,
  input [31:0] addr_in,
  input [5:0] state_in,
  input data_we_in,
  input data_re_in,
  input [127:0] data_in,
  output reg [5:0] state_out,
  output reg [127:0] data_out
);reg [5:0] state_memory [0:127]; // Assumes 128 entries for state
  reg [127:0] data_memory [0:127]; // Assumes 128 entries for data

  // State memory write and read
  always @(posedge clk) begin
    if (state_we_in) begin
      state_memory[addr_in[10:4]] <= state_in;
    end
    if (state_re_in) begin
      state_out <= state_memory[addr_in[10:4]];
    end
  end

  // Data memory write and read
  always @(posedge clk) begin
    if (data_we_in) begin
      data_memory[addr_in[10:4]] <= data_in;
    end
    if (data_re_in) begin
      data_out <= data_memory[addr_in[10:4]];
    end
  end

endmodule