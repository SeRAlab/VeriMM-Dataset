module fifo_queue #(parameter SIZE = 8, DATA_WIDTH = 8) (
    input clk,
    input reset,
    input [DATA_WIDTH-1:0] enqueue,
    input dequeue,
    output reg [DATA_WIDTH-1:0] fifo_out,
    output reg full,
    output reg empty
);
    reg [DATA_WIDTH-1:0] fifo [0:SIZE-1];
    reg [3:0] head, tail, count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (enqueue && !full) begin
                fifo[tail] <= enqueue;
                tail <= (tail + 1) % SIZE;
                count <= count + 1;
            end
            if (dequeue && !empty) begin
                fifo_out <= fifo[head];
                head <= (head + 1) % SIZE;
                count <= count - 1;
            end

            full <= (count == SIZE);
            empty <= (count == 0);
        end
    end
endmodule