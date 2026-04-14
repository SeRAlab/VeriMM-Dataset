module fifo_queue (
    input clk,
    input rst,
    input enqueue,
    input dequeue,
    input [3:0] data_in,
    output reg [3:0] data_out,
    output reg full,
    output reg empty
);
    reg [3:0] queue [3:0]; // 4 depth FIFO
    reg [1:0] head, tail, count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
            data_out <= 0;
        end else begin
            if (enqueue && !full) begin
                queue[tail] <= data_in;
                tail <= (tail + 1) % 4;
                count <= count + 1;
            end
            if (dequeue && !empty) begin
                data_out <= queue[head];
                head <= (head + 1) % 4;
                count <= count - 1;
            end
            full <= (count == 4);
            empty <= (count == 0);
        end
    end
endmodule