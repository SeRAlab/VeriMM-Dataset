module fifo_queue (
    input clk,
    input push,
    input pop,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    reg [7:0] fifo [3:0]; // 4-depth FIFO
    reg [1:0] head;       // points to the next empty position
    reg [1:0] tail;       // points to the next data to pop

    initial begin
        head = 0;
        tail = 0;
        full = 0;
        empty = 1;
    end

    always @(posedge clk) begin
        if (push && !full) begin
            fifo[head] <= data_in;
            head <= head + 1;
            if (head == 3) full <= 1;
            empty <= 0;
        end

        if (pop && !empty) begin
            data_out <= fifo[tail];
            tail <= tail + 1;
            if (tail == 3) empty <= 1;
            full <= 0;
        end

        if (head == tail) begin
            full <= 0;
            empty <= 1;
        end
    end
endmodule