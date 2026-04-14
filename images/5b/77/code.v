module top_module(
  input clk,
  input rst,
  input [31:0] addr,
  input we,
  input [31:0] wd,
  input rd_en,
  input [3:0] burst_len,
  input [1:0] burst_type,
  output reg [31:0] rd_data
);// Define memory control signals
  reg [31:0] mem_addr;
  reg [31:0] mem_wd;
  reg mem_we;
  reg mem_rd_en;
  reg [3:0] mem_burst_len;
  reg [1:0] mem_burst_type;

  // Define data path
  reg [31:0] data_in;
  reg [31:0] data_out;

  // Address pipelining
  reg [31:0] addr_reg;
  always @(posedge clk) begin
    if (rst) begin
      addr_reg <= 0;
    end else begin
      addr_reg <= addr;
    end
  end

  // Burst transfer support
  reg [3:0] burst_count;
  reg burst_active;
  always @(posedge clk) begin
    if (rst) begin
      burst_count <= 0;
      burst_active <= 0;
    end else if (burst_active) begin
      if (burst_count == burst_len) begin
        burst_count <= 0;
        burst_active <= 0;
      end else begin
        burst_count <= burst_count + 1;
      end
    end
  end

  // Memory control signal generation
  always @(posedge clk) begin
    if (rst) begin
      mem_addr <= 0;
      mem_wd <= 0;
      mem_we <= 0;
      mem_rd_en <= 0;
      mem_burst_len <= 0;
      mem_burst_type <= 0;
    end else begin
      mem_addr <= addr_reg;
      mem_wd <= wd;
      mem_we <= we;
      mem_rd_en <= rd_en;
      mem_burst_len <= burst_len;
      mem_burst_type <= burst_type;
    end
  end

  // Data path
  always @(posedge clk) begin
    if (rst) begin
      data_in <= 0;
      data_out <= 0;
    end else begin
      data_in <= wd;
      if (rd_en) begin
        data_out <= rd_data;
      end
    end
  end

  // Connect to memory device
  // (implementation details depend on the type of memory device)

endmodule