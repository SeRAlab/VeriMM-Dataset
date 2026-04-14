module top_module(output reg [255:0]DOUTB,
    input tmp_ram_rd_en,
    input rd_clk,
    input [0:0]Q,
    input I1,
    input wr_clk,
    input [8:0]O2,
    input [8:0]I2,
    input [255:0]din);reg [255:0] ram [0:255];
  reg [8:0] rd_ptr = 0;
  reg [8:0] wr_ptr = 0;
  reg [0:0] empty = 1;
  reg [0:0] full = 0;
  
  always @ (posedge wr_clk) begin
    if (!full) begin
      ram[wr_ptr] <= din;
      wr_ptr <= wr_ptr + 1;
      if (wr_ptr == 255) begin
        wr_ptr <= 0;
      end
      empty <= 0;
      if (wr_ptr == rd_ptr) begin
        full <= 1;
      end
    end
  end
  
  always @ (posedge rd_clk) begin
    if (!empty) begin
      DOUTB <= ram[rd_ptr];
      rd_ptr <= rd_ptr + 1;
      if (rd_ptr == 255) begin
        rd_ptr <= 0;
      end
      full <= 0;
      if (rd_ptr == wr_ptr) begin
        empty <= 1;
      end
    end
  end
  
endmodule