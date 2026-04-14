module NVMeQueueManager (
    input clk,
    input rst_n,
    input enqueue,
    input dequeue,
    input [31:0] command_in,
    output reg [31:0] command_out,
    output reg full,
    output reg empty
);
    reg [31:0] queue [0:3]; // FIFO queue of size 4
    reg [1:0] head;
    reg [1:0] tail;
    reg [2:0] count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (enqueue && !full) begin
                queue[tail] <= command_in;
                tail <= tail + 1;
                count <= count + 1;
                empty <= 0;
                if (count == 3)
                    full <= 1;
            end

            if (dequeue && !empty) begin
                command_out <= queue[head];
                head <= head + 1;
                count <= count - 1;
                full <= 0;
                if (count == 1)
                    empty <= 1;
            end
        end
    end
endmodule