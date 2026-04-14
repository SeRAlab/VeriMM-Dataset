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
    output reg empty,
    output reg full
);

reg [WIDTH-1:0] mem [0:DEPTH-1];
reg [4:0] wr_ptr;
reg [4:0] rd_ptr;
reg [5:0] count;

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        wr_ptr <= 0;
        rd_ptr <= 0;
        count <= 0;
        empty <= 1;
        full <= 0;
    end else begin
        if (wr_en && !full) begin
            mem[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
            count <= count + 1;
        end
        if (rd_en && !empty) begin
            data_out <= mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            count <= count - 1;
        end
        empty <= (count == 0);
        full <= (count == DEPTH);
    end
end

endmodule