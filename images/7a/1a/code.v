module dual_port_ram(
  input clk,
  input we,
  input [7:0] write_address,
  input [7:0] read_address,
  input [7:0] data_in,
  output reg [7:0] data_out
);

  reg [7:0] memory [255:0];

  always @(posedge clk) begin
    if (we) begin
      memory[write_address] <= data_in;
    end
    data_out <= memory[read_address];
  end

endmodule