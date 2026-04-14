module fifo_queue (
    input clk,
    input reset,
    input enqueue,
    input dequeue,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg is_empty,
    output reg is_full
);
    reg [7:0] fifo [0:7]; // 8 entries
    reg [2:0] head; // Points to the head of the FIFO
    reg [2:0] tail; // Points to the tail of the FIFO
    reg [3:0] count; // Number of items in the FIFO

    initial begin
        head = 0;
        tail = 0;
        count = 0;
        data_out = 8'b0;
        is_empty = 1;
        is_full = 0;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            data_out <= 8'b0;
            is_empty <= 1;
            is_full <= 0;
        end else begin
            if (enqueue && !is_full) begin
                fifo[tail] <= data_in;
                tail <= (tail + 1) % 8;
                count <= count + 1;
            end
            
            if (dequeue && !is_empty) begin
                data_out <= fifo[head];
                head <= (head + 1) % 8;
                count <= count - 1;
            end
            
            is_empty <= (count == 0);
            is_full <= (count == 8);
        end
    end
endmodule