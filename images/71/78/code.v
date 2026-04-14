module register_file(
  input clk,
  input rst_n,
  input we,
  input [2:0] write_addr,
  input [2:0] read_addr,
  input [15:0] data_in,
  output [15:0] data_out
);

  reg [15:0] reg_file [7:0];
  integer i;

  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
      for (i = 0; i < 8; i = i + 1) begin
        reg_file[i] <= 16'b0;
      end
    end
    else if (we) begin
      reg_file[write_addr] <= data_in;
    end
  end

  assign data_out = reg_file[read_addr];

endmodule