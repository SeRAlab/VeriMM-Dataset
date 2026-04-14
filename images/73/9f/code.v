module top_module(
  clk,
  rst,
  din,
  wr_en,
  rd_en,
  dout,
  full,
  empty,
  data_count
);input clk;
input rst;
input [127 : 0] din;
input wr_en;
input rd_en;
output reg [127 : 0] dout; // Change to output reg
output full;
output empty;
output [4 : 0] data_count;

reg [127:0] fifo_mem [0:15];
reg [3:0] wr_ptr;
reg [3:0] rd_ptr;
reg [4:0] cnt;

assign full = (cnt == 16);
assign empty = (cnt == 0);
assign data_count = cnt;

always @(posedge clk) begin
    if (rst) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        cnt <= 0;
        dout <= 0; // Initialize dout on reset
    end else begin
        if (wr_en && !full) begin
            fifo_mem[wr_ptr] <= din;
            wr_ptr <= wr_ptr + 1;
            cnt <= cnt + 1;
        end
        if (rd_en && !empty) begin
            dout <= fifo_mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            cnt <= cnt - 1;
        end
    end
end

endmodule