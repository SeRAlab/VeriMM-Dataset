module fifo_queue (
    input clk,
    input rst,
    input [7:0] data_in,
    input enqueue,
    input dequeue,
    output reg [7:0] data_out,
    output reg valid
);
    reg [7:0] fifo [0:3];
    reg [1:0] head, tail;
    reg [2:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            valid <= 0;
        end else begin
            if (enqueue && count < 4) begin
                fifo[tail] <= data_in;
                tail <= (tail + 1) % 4;
                count <= count + 1;
            end
            if (dequeue && count > 0) begin
                data_out <= fifo[head];
                valid <= 1;
                head <= (head + 1) % 4;
                count <= count - 1;
            end else begin
                valid <= 0;
            end
        end
    end
endmodule