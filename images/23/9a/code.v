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
    reg [7:0] fifo [3:0]; // 4 depth FIFO
    reg [1:0] head;
    reg [1:0] tail;
    reg [2:0] count; // Track number of items in FIFO

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 2'b00;
            tail <= 2'b00;
            count <= 3'b000;
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
            full <= (count == 3'b100); // FIFO is full if count is 4
            empty <= (count == 3'b000); // FIFO is empty if count is 0
        end
    end
endmodule