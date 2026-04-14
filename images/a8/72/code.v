module fifo#(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output wire empty,
    output wire full
);

reg [WIDTH-1:0] mem [0:DEPTH-1];
reg [$clog2(DEPTH)-1:0] rd_ptr, wr_ptr;
reg [DEPTH:0] fifo_count;

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        rd_ptr <= 0;
        wr_ptr <= 0;
        fifo_count <= 0;
    end else begin
        if (wr_en && !full) begin
            mem[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
            fifo_count <= fifo_count + 1;
        end
        if (rd_en && !empty) begin
            data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            fifo_count <= fifo_count - 1;
        end
    end
end

assign empty = (fifo_count == 0);
assign full = (fifo_count == DEPTH);

endmodule