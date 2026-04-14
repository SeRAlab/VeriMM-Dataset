module fifo #(parameter DATA_WIDTH = 8, parameter DEPTH = 16) (
    input wire clk,
    input wire rst,
    input wire enqueue,
    input wire dequeue,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg full,
    output reg empty
);

    reg [DATA_WIDTH-1:0] fifo_mem [0:DEPTH-1];
    reg [4:0] read_ptr, write_ptr;
    reg [4:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            read_ptr <= 0;
            write_ptr <= 0;
            count <= 0;
            empty <= 1;
            full <= 0;
        end else begin
            if (enqueue && !full) begin
                fifo_mem[write_ptr] <= data_in;
                write_ptr <= (write_ptr + 1) % DEPTH;
                count <= count + 1;
            end

            if (dequeue && !empty) begin
                data_out <= fifo_mem[read_ptr];
                read_ptr <= (read_ptr + 1) % DEPTH;
                count <= count - 1;
            end

            empty <= (count == 0);
            full <= (count == DEPTH);
        end
    end
endmodule