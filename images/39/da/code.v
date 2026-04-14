module fifo_queue #(parameter DEPTH = 8, parameter DATA_WIDTH = 8) (
    input wire clk,
    input wire rst,
    input wire enqueue,
    input wire dequeue,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg is_empty,
    output reg is_full
);
    reg [DATA_WIDTH-1:0] queue [0:DEPTH-1];
    reg [3:0] head, tail;
    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            is_empty <= 1;
            is_full <= 0;
        end else begin
            if (enqueue && !is_full) begin
                queue[tail] <= data_in;
                tail <= (tail + 1) % DEPTH;
                count <= count + 1;
            end
            if (dequeue && !is_empty) begin
                data_out <= queue[head];
                head <= (head + 1) % DEPTH;
                count <= count - 1;
            end
            is_empty <= (count == 0);
            is_full <= (count == DEPTH);
        end
    end
endmodule