module fifo_queue #(parameter WIDTH = 8, parameter DEPTH = 16) (
    input clk,
    input rst_n,
    input [WIDTH-1:0] data_in,
    input enqueue,
    input dequeue,
    output reg [WIDTH-1:0] data_out,
    output reg full,
    output reg empty
);
    reg [WIDTH-1:0] memory [0:DEPTH-1];
    reg [3:0] head, tail, count;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
        end else begin
            if (enqueue && !full) begin
                memory[tail] <= data_in;
                tail <= (tail + 1) % DEPTH;
                count <= count + 1;
            end
            if (dequeue && !empty) begin
                data_out <= memory[head];
                head <= (head + 1) % DEPTH;
                count <= count - 1;
            end
            empty <= (count == 0);
            full <= (count == DEPTH);
        end
    end
endmodule