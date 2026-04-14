module fifo_queue (
    input clk,
    input rst,
    input [7:0] data_in,
    input enqueue,
    input dequeue,
    output reg [7:0] data_out,
    output reg full,
    output reg empty,
    output reg [2:0] size
);
    reg [7:0] queue [3:0]; // 4-depth FIFO
    reg [1:0] head, tail;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            size <= 0;
            empty <= 1;
            full <= 0;
        end else begin
            if (enqueue && !full) begin
                queue[head] <= data_in;
                head <= (head + 1) % 4;
                size <= size + 1;
                empty <= 0;
                if (size == 3) full <= 1;
            end
            if (dequeue && !empty) begin
                data_out <= queue[tail];
                tail <= (tail + 1) % 4;
                size <= size - 1;
                full <= 0;
                if (size == 1) empty <= 1;
            end
        end
    end
endmodule