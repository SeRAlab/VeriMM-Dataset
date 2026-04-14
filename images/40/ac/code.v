module fifo_queue #(parameter DEPTH = 8, parameter DATA_WIDTH = 8) (
    input clk,
    input reset,
    input enqueue,
    input dequeue,
    input [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg full,
    output reg empty
);
    reg [DATA_WIDTH-1:0] queue [0:DEPTH-1];
    reg [3:0] head, tail, count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            empty <= 1;
            full <= 0;
        end else begin
            if (enqueue && !full) begin
                queue[tail] <= data_in;
                tail <= (tail + 1) % DEPTH;
                count <= count + 1;
            end

            if (dequeue && !empty) begin
                data_out <= queue[head];
                head <= (head + 1) % DEPTH;
                count <= count - 1;
            end

            empty <= (count == 0);
            full <= (count == DEPTH);
        end
    end
endmodule