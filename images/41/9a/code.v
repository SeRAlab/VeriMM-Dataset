module top_module(
  rst,
  wr_clk,
  rd_clk,
  din,
  wr_en,
  rd_en,
  dout,
  full,
  empty,
  rd_data_count,
  wr_data_count
);input rst;
input wr_clk;
input rd_clk;
input [63 : 0] din;
input wr_en;
input rd_en;
output [63 : 0] dout;
output full;
output empty;
output [8 : 0] rd_data_count;
output [8 : 0] wr_data_count;

reg [63:0] mem [511:0];
reg [8:0] rd_ptr;
reg [8:0] wr_ptr;
reg [8:0] rd_data_count_reg;
reg [8:0] wr_data_count_reg;
wire [8:0] rd_data_count;
wire [8:0] wr_data_count;

assign rd_data_count = rd_data_count_reg;
assign wr_data_count = wr_data_count_reg;

assign full = ((wr_ptr == rd_ptr) && wr_en && !rd_en);
assign empty = ((wr_ptr == rd_ptr) && !wr_en && rd_en);

assign dout = mem[rd_ptr];

always @(posedge wr_clk or negedge rst) begin
  if (!rst) begin
    wr_ptr <= 0;
    wr_data_count_reg <= 0;
  end else if (wr_en && !full) begin
    mem[wr_ptr] <= din;
    wr_ptr <= wr_ptr + 1;
    wr_data_count_reg <= wr_data_count_reg + 1;
  end
end

always @(posedge rd_clk or negedge rst) begin
  if (!rst) begin
    rd_ptr <= 0;
    rd_data_count_reg <= 0;
  end else if (rd_en && !empty) begin
    rd_ptr <= rd_ptr + 1;
    rd_data_count_reg <= rd_data_count_reg + 1;
  end
end

endmodule