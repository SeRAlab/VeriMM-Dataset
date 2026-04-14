module top_module(clk, rst_l, data_in, wr_en, rd_en, data_out, empty, full);parameter DEPTH = 64;
parameter WIDTH = 8;

input clk;
input rst_l;
input [WIDTH-1:0] data_in;
input wr_en;
input rd_en;

output reg [WIDTH-1:0] data_out; // Changed to reg to allow assignment
output empty;
output full;

reg [WIDTH-1:0] mem [0:DEPTH-1];
reg [6:0] wr_ptr = 0;
reg [6:0] rd_ptr = 0;
reg [6:0] count = 0; // Changed from DEPTH-1 to 6:0 for proper range

assign empty = (count == 0);
assign full = (count == DEPTH);

always @(posedge clk or negedge rst_l) begin
    if (~rst_l) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        count <= 0;
    end else begin
        if (wr_en && ~full) begin
            mem[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
            count <= count + 1;
        end
        if (rd_en && ~empty) begin
            data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            count <= count - 1;
        end
    end
end

endmodule