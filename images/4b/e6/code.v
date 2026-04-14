module top_module(
  input wr_clk,
  input rd_clk,
  input rst,
  input rd_en,
  input p_18_out,
  output [31:0] Q,
  output rst_full_ff_i,
  output rst_full_gen_i,
  output tmp_ram_rd_en
);parameter DATA_WIDTH = 32;
  parameter ADDR_WIDTH = 14;
  parameter RAM_DEPTH = 2**ADDR_WIDTH;
  parameter RAM_WIDTH = DATA_WIDTH + ADDR_WIDTH;
  
  reg [ADDR_WIDTH-1:0] wr_addr;
  reg [ADDR_WIDTH-1:0] rd_addr;
  wire [ADDR_WIDTH-1:0] next_wr_addr;
  wire [ADDR_WIDTH-1:0] next_rd_addr;
  wire [ADDR_WIDTH-1:0] wr_addr_plus_1;
  wire [ADDR_WIDTH-1:0] rd_addr_plus_1;
  reg [RAM_WIDTH-1:0] ram [RAM_DEPTH-1:0];
  reg [31:0] count;
  wire full;
  
  assign next_wr_addr = (wr_addr == (RAM_DEPTH-1)) ? 0 : (wr_addr + 1);
  assign next_rd_addr = (rd_addr == (RAM_DEPTH-1)) ? 0 : (rd_addr + 1);
  assign wr_addr_plus_1 = (wr_addr == (RAM_DEPTH-1)) ? 0 : (wr_addr + 1);
  assign rd_addr_plus_1 = (rd_addr == (RAM_DEPTH-1)) ? 0 : (rd_addr + 1);
  assign full = (count == RAM_DEPTH);
  assign tmp_ram_rd_en = 1'b1;
  assign rst_full_ff_i = full;
  assign rst_full_gen_i = full;
  assign Q = ram[rd_addr][DATA_WIDTH-1:0];
  
  always @(posedge wr_clk) begin
    if (rst) begin
      wr_addr <= 0;
      count <= 0;
    end else if (count < RAM_DEPTH) begin
      ram[wr_addr] <= {p_18_out, wr_addr};
      wr_addr <= next_wr_addr;
      count <= count + 1;
    end
  end
  
  always @(posedge rd_clk) begin
    if (rst) begin
      rd_addr <= 0;
      count <= 0;
    end else if (count > 0 && rd_en) begin
      rd_addr <= next_rd_addr;
      count <= count - 1;
    end
  end

endmodule