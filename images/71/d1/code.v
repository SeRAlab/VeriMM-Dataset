module top_module(
    rd_en,
    wr_en,
    clk,
    rst,
    din,
    wr_rst_busy,
    empty,
    full,
    almost_full,
    dout
);parameter DEPTH = 16;
parameter WIDTH = 65;

input rd_en;
input wr_en;
input clk;
input rst;
input [WIDTH-1:0] din;

output wr_rst_busy;
output empty;
output full;
output almost_full;
output reg [WIDTH-1:0] dout; // Change wire to reg

reg [WIDTH-1:0] ram [DEPTH-1:0];
reg [4:0] wr_ptr = 0;
reg [4:0] rd_ptr = 0;
wire [4:0] next_wr_ptr = wr_ptr + 1;
wire [4:0] next_rd_ptr = rd_ptr + 1;

assign wr_rst_busy = wr_en || rst;
assign empty = (wr_ptr == rd_ptr);
assign full = (next_wr_ptr == rd_ptr);
assign almost_full = (wr_ptr == next_rd_ptr);

always @(posedge clk) begin
    if (rst) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        dout <= 0; // Initialize dout to 0 during reset
    end else begin
        if (wr_en && !full) begin
            ram[wr_ptr] <= din;
            wr_ptr <= next_wr_ptr;
        end
        if (rd_en && !empty) begin
            dout <= ram[rd_ptr];
            rd_ptr <= next_rd_ptr;
        end
    end
end

endmodule