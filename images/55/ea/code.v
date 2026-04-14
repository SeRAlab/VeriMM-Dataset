module top_module(
  input clk,
  input rst_n,
  input write_en,
  input [7:0] write_addr,
  input [7:0] data_in,
  input read_en1,
  input [7:0] read_addr1,
  input read_en2,
  input [7:0] read_addr2,
  output reg [7:0] data_out
);reg [7:0] ram [0:15];
  reg [7:0] shift_reg;

  integer i;
  initial begin
    for (i = 0; i < 16; i = i + 1) begin
      ram[i] = 8'h00;
    end
  end

  always @(posedge clk) begin
    if (!rst_n) begin
      shift_reg <= 8'h00;
    end else begin
      shift_reg <= {shift_reg[6:0], data_in};
    end
  end

  always @(posedge clk) begin
    if (write_en) begin
      ram[write_addr] <= data_in;
    end
  end

  always @(posedge clk) begin
    if (read_en1) begin
      data_out <= ram[read_addr1];
    end else if (read_en2) begin
      data_out <= ram[read_addr2];
    end
  end

endmodule