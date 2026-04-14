module fifo_queue (
    input clk,
    input reset,
    input [7:0] enqueue,
    input dequeue,
    output reg [7:0] front,
    output reg full,
    output reg empty
);
    reg [7:0] queue [3:0];
    reg [1:0] head, tail;
    reg [2:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 2'b00;
            tail <= 2'b00;
            count <= 3'b000;
            full <= 1'b0;
            empty <= 1'b1;
            front <= 8'b0;
        end else begin
            if (dequeue && !empty) begin
                front <= queue[head];
                head <= (head + 1) % 4;
                count <= count - 1;
            end
            if (enqueue && !full) begin
                queue[tail] <= enqueue;
                tail <= (tail + 1) % 4;
                count <= count + 1;
            end
            full <= (count == 3'b100);
            empty <= (count == 3'b000);
        end
    end
endmodule