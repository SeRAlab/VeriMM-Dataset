module fifo_queue (
    input clk,
    input rst,
    input [7:0] data_in,
    input write_enable,
    input read_enable,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    reg [7:0] fifo [3:0]; // Queue of depth 4
    reg [1:0] head, tail; // Pointers to track head and tail

    initial begin
        head = 2'b00;
        tail = 2'b00;
        full = 0;
        empty = 1;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 2'b00;
            tail <= 2'b00;
            full <= 0;
            empty <= 1;
        end else begin
            if (write_enable && !full) begin
                fifo[tail] <= data_in;
                tail <= (tail + 1) % 4;
                empty <= 0;
                if ((tail + 1) % 4 == head) begin
                    full <= 1;
                end
            end
            if (read_enable && !empty) begin
                data_out <= fifo[head];
                head <= (head + 1) % 4;
                full <= 0;
                if (head == tail) begin
                    empty <= 1;
                end
            end
        end
    end
endmodule