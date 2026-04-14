module fifo_queue #(parameter DATA_WIDTH = 8, parameter FIFO_DEPTH = 16) (
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [DATA_WIDTH-1:0] wr_data,
    output reg [DATA_WIDTH-1:0] rd_data,
    output reg full,
    output reg empty
);

    reg [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1];
    reg [3:0] wr_ptr;
    reg [3:0] rd_ptr;
    reg [4:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (wr_en && !full) begin
                fifo_mem[wr_ptr] <= wr_data;
                wr_ptr <= (wr_ptr + 1) % FIFO_DEPTH;
                count <= count + 1;
            end
            if (rd_en && !empty) begin
                rd_data <= fifo_mem[rd_ptr];
                rd_ptr <= (rd_ptr + 1) % FIFO_DEPTH;
                count <= count - 1;
            end
            full <= (count == FIFO_DEPTH);
            empty <= (count == 0);
        end
    end
endmodule