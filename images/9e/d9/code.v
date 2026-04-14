module top_module(
  input rst,
  input wr_clk,
  input rd_clk,
  input [30:0] din,
  input wr_en,
  input rd_en,
  output reg [30:0] dout,  // Changed to reg
  output full,
  output empty
);reg [30:0] mem [0:15];
reg [3:0] wr_ptr;
reg [3:0] rd_ptr;
wire [3:0] next_wr_ptr;
wire [3:0] next_rd_ptr;
wire [3:0] wr_ptr_plus_1;
wire [3:0] rd_ptr_plus_1;
wire [3:0] rd_ptr_plus_2;
wire [3:0] mem_count;
wire [3:0] mem_count_plus_1;
wire [3:0] mem_count_minus_1;

assign wr_ptr_plus_1 = wr_ptr + 1;
assign rd_ptr_plus_1 = rd_ptr + 1;
assign rd_ptr_plus_2 = rd_ptr + 2;
assign mem_count = wr_ptr - rd_ptr;
assign mem_count_plus_1 = wr_ptr_plus_1 - rd_ptr;
assign mem_count_minus_1 = wr_ptr - rd_ptr_plus_1;

assign full = (mem_count_plus_1 == 16);
assign empty = (mem_count == 0);

assign next_wr_ptr = (wr_en && !full) ? wr_ptr_plus_1 : wr_ptr;
assign next_rd_ptr = (rd_en && !empty) ? rd_ptr_plus_1 : rd_ptr;

always @(posedge wr_clk) begin
  if (rst) begin
    wr_ptr <= 0;
  end else begin
    wr_ptr <= next_wr_ptr;
    mem[wr_ptr] <= din;
  end
end

always @(posedge rd_clk) begin
  if (rst) begin
    rd_ptr <= 0;
  end else begin
    rd_ptr <= next_rd_ptr;
    dout <= mem[rd_ptr]; // No change needed here
  end
end

endmodule