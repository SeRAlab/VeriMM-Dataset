module fifo_queue (
    input clk,
    input rst,
    input [7:0] data_in,
    input enqueue,
    input dequeue,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    reg [7:0] queue [0:3];
    reg [1:0] head;
    reg [1:0] tail;
    reg [1:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
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