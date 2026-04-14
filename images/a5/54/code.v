module top_module(dout,
    E,
    wr_clk,
    tmp_ram_rd_en,
    rd_clk,
    Q,
    din);output reg [31:0] dout;
  output reg E;
  output reg Q;
  input [31:0] din;
  input wr_clk;
  input tmp_ram_rd_en;
  input rd_clk;

  parameter DATA_WIDTH = 32;
  parameter ADDR_WIDTH = 15;
  parameter MEM_DEPTH = 1 << ADDR_WIDTH;

  reg [ADDR_WIDTH-1:0] wr_ptr;
  reg [ADDR_WIDTH-1:0] rd_ptr;
  reg [ADDR_WIDTH-1:0] mem_addr;
  reg [31:0] mem [0:MEM_DEPTH-1];
  reg [31:0] tmp_ram [0:MEM_DEPTH-1];

  wire [ADDR_WIDTH-1:0] next_wr_ptr;
  wire [ADDR_WIDTH-1:0] next_rd_ptr;

  assign next_wr_ptr = (wr_ptr == MEM_DEPTH-1) ? 0 : wr_ptr + 1;
  assign next_rd_ptr = (rd_ptr == MEM_DEPTH-1) ? 0 : rd_ptr + 1;

  always @(posedge wr_clk) begin
    if (Q == 0) begin
      mem[wr_ptr] <= din;
      wr_ptr <= next_wr_ptr;
      if (wr_ptr == rd_ptr)
        Q <= 1;
    end
  end

  always @(posedge rd_clk) begin
    if (E == 0) begin
      dout <= mem[rd_ptr];
      rd_ptr <= next_rd_ptr;
      if (rd_ptr == wr_ptr)
        E <= 1;
    end
  end

  always @(posedge tmp_ram_rd_en) begin
    if (Q == 0) begin
      tmp_ram[wr_ptr] <= din;
      if (wr_ptr == rd_ptr)
        Q <= 1;
    end
  end

  always @(posedge rd_clk) begin
    if (E == 0) begin
      dout <= tmp_ram[rd_ptr];
      if (rd_ptr == wr_ptr)
        E <= 1;
    end
  end

  always @(*) begin
    if (wr_ptr == rd_ptr) begin
      if (Q == 1)
        Q <= 0;
      if (E == 0)
        E <= 1;
    end else begin
      if (Q == 0)
        Q <= 1;
      if (E == 1)
        E <= 0;
    end
  end

endmodule