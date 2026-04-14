module fifo_queue #(
    parameter DEPTH = 8,
    parameter WIDTH = 8
)(
    input clk,
    input rst,
    input enqueue,
    input dequeue,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output reg overflow,
    output reg underflow,
    output reg [3:0] count
);
    reg [WIDTH-1:0] fifo_mem [0:DEPTH-1];
    reg [3:0] head;
    reg [3:0] tail;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            overflow <= 0;
            underflow <= 0;
        end else begin
            if (enqueue) begin
                if (count < DEPTH) begin
                    fifo_mem[tail] <= data_in;
                    tail <= (tail + 1) % DEPTH;
                    count <= count + 1;
                    overflow <= 0;
                end else begin
                    overflow <= 1;
                end
            end

            if (dequeue) begin
                if (count > 0) begin
                    data_out <= fifo_mem[head];
                    head <= (head + 1) % DEPTH;
                    count <= count - 1;
                    underflow <= 0;
                end else begin
                    underflow <= 1;
                end
            end
        end
    end
endmodule