module top_module(
    clk,
    rst,
    wr_en,
    wr_data,
    rd_en,
    rd_data,
    empty,
    full
);parameter WIDTH = 8;
parameter DEPTH = 16;

input clk;
input rst;
input wr_en;
input [WIDTH-1:0] wr_data;
input rd_en;
output reg [WIDTH-1:0] rd_data;  // Change to reg
output empty;
output full;

reg [WIDTH-1:0] mem [0:DEPTH-1];
reg [4:0] wr_ptr = 0;
reg [4:0] rd_ptr = 0;
reg [4:0] count = 0;

assign empty = (count == 0);
assign full = (count == DEPTH);

always @(posedge clk) begin
    if (rst) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        count <= 0;
    end else begin
        if (wr_en && !full) begin
            mem[wr_ptr] <= wr_data;
            wr_ptr <= (wr_ptr == DEPTH-1) ? 0 : wr_ptr + 1;
            count <= count + 1;
        end
        if (rd_en && !empty) begin
            rd_data <= mem[rd_ptr];
            rd_ptr <= (rd_ptr == DEPTH-1) ? 0 : rd_ptr + 1;
            count <= count - 1;
        end
    end
end

endmodule