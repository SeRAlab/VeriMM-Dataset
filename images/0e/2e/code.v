module fifo_queue #(parameter DEPTH = 4, DATA_WIDTH = 8) (
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [DATA_WIDTH-1:0] data_in,
    output reg valid,
    output reg [DATA_WIDTH-1:0] data_out
);
    reg [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];
    reg [3:0] write_ptr, read_ptr;
    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            write_ptr <= 0;
            read_ptr <= 0;
            count <= 0;
            valid <= 0;
        end else begin
            if (wr_en && count < DEPTH) begin
                fifo_mem[write_ptr] <= data_in;
                write_ptr <= (write_ptr + 1) % DEPTH;
                count <= count + 1;
            end
            if (rd_en && count > 0) begin
                data_out <= fifo_mem[read_ptr];
                read_ptr <= (read_ptr + 1) % DEPTH;
                count <= count - 1;
                valid <= 1;
            end else begin
                valid <= 0;
            end
        end
    end
endmodule