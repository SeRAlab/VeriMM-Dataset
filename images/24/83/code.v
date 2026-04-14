module fifo_queue (
    input clk,
    input rst,
    input enqueue,
    input dequeue,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    parameter SIZE = 8;
    reg [7:0] queue [0:SIZE-1];
    reg [3:0] head;
    reg [3:0] tail;
    reg [3:0] count;

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
                tail <= (tail + 1) % SIZE;
                count <= count + 1;
                empty <= 0;
                if (count == SIZE-1)
                    full <= 1;
            end
            if (dequeue && !empty) begin
                data_out <= queue[head];
                head <= (head + 1) % SIZE;
                count <= count - 1;
                full <= 0;
                if (count == 1)
                    empty <= 1;
            end
        end
    end
endmodule