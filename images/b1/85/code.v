module top_module(dout,
   rd_clk,
   wr_clk,
   tmp_ram_rd_en,
   WEBWE,
   Q,
   count_d1_reg,
   count_d2_reg,
   din);parameter DATA_WIDTH = 32;
  parameter ADDR_WIDTH = 14;
  parameter DEPTH = 1 << ADDR_WIDTH;
  
  output reg [DATA_WIDTH-1:0] dout; // Changed to reg type to allow assignment in always block
  input rd_clk;
  input wr_clk;
  input tmp_ram_rd_en;
  input [0:0] WEBWE;
  output [0:0] Q;
  input [DATA_WIDTH-1:0] din;
  input [8:0] count_d1_reg;
  input [8:0] count_d2_reg;

  reg [ADDR_WIDTH-1:0] wr_ptr;
  reg [ADDR_WIDTH-1:0] rd_ptr;
  reg [ADDR_WIDTH-1:0] wr_ptr_next;
  reg [ADDR_WIDTH-1:0] rd_ptr_next;
  reg [DATA_WIDTH-1:0] mem [0:DEPTH-1]; // Corrected the array type to match DATA_WIDTH
  reg [31:0] count_d1;
  reg [31:0] count_d2;

  assign Q = (count_d1 == count_d2) ? 1'b1 : 1'b0;

  always @(posedge wr_clk) begin
    if (WEBWE) begin
      mem[wr_ptr] <= din;
      wr_ptr <= wr_ptr_next;
      count_d1 <= count_d1 + 1;
    end
  end

  always @(posedge rd_clk) begin
    if (Q == 1'b0) begin
      dout <= mem[rd_ptr];
      rd_ptr <= rd_ptr_next;
      count_d2 <= count_d2 + 1;
    end
  end

  always @(posedge wr_clk) begin
    wr_ptr_next <= (wr_ptr == DEPTH-1) ? 0 : wr_ptr + 1;
  end

  always @(posedge rd_clk) begin
    rd_ptr_next <= (rd_ptr == DEPTH-1) ? 0 : rd_ptr + 1;
  end

endmodule