module fifo_queue (
    input clk,
    input reset,
    input [3:0] data_in,
    input enqueue,
    input dequeue,
    output reg [3:0] data_out,
    output reg full,
    output reg empty
);
    reg [3:0] fifo [3:0]; // 4 entries of 4-bit wide
    reg [1:0] head, tail, count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 2'b00;
            tail <= 2'b00;
            count <= 2'b00;
            full <= 1'b0;
            empty <= 1'b1;
        end else begin
            if (enqueue && !full) begin
                fifo[tail] <= data_in;
                tail <= (tail + 1) % 4;
                count <= count + 1;
            end
            if (dequeue && !empty) begin
                data_out <= fifo[head];
                head <= (head + 1) % 4;
                count <= count - 1;
            end
            full <= (count == 4);
            empty <= (count == 0);
        end
    end
endmodule