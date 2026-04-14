module fifo_queue #(parameter DEPTH = 8, DATA_WIDTH = 8) (
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [DATA_WIDTH-1:0] input_data,
    output reg [DATA_WIDTH-1:0] output_data,
    output reg full,
    output reg empty
);
    reg [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];
    reg [3:0] wr_ptr, rd_ptr, count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
            output_data <= 0;
        end else begin
            if (wr_en && !full) begin
                fifo_mem[wr_ptr] <= input_data;
                wr_ptr <= (wr_ptr + 1) % DEPTH;
                count <= count + 1;
            end
            if (rd_en && !empty) begin
                output_data <= fifo_mem[rd_ptr];
                rd_ptr <= (rd_ptr + 1) % DEPTH;
                count <= count - 1;
            end
            full <= (count == DEPTH);
            empty <= (count == 0);
        end
    end
endmodule