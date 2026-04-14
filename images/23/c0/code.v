module fifo_queue (
    input clk,
    input [3:0] data_in,
    input write_en,
    input read_en,
    output reg [3:0] data_out,
    output reg full,
    output reg empty
);
    reg [3:0] fifo [3:0]; // 4 entries of 4 bits each
    reg [1:0] head, tail, count;

    initial begin
        head = 2'b00;
        tail = 2'b00;
        count = 2'b00;
        full = 1'b0;
        empty = 1'b1;
    end

    always @(posedge clk) begin
        if (write_en && !full) begin
            fifo[tail] <= data_in;
            tail <= tail + 1'b1;
            count <= count + 1'b1;
        end
        if (read_en && !empty) begin
            data_out <= fifo[head];
            head <= head + 1'b1;
            count <= count - 1'b1;
        end

        full <= (count == 2'b11);
        empty <= (count == 2'b00);
    end
endmodule