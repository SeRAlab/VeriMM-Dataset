module fifo_queue (
    input clk,
    input reset,
    input [7:0] data_in,
    input wr_en,
    input rd_en,
    output reg [7:0] data_out,
    output reg empty
);
    reg [7:0] fifo [3:0]; // 4x8 FIFO storage
    reg [1:0] head; // Pointer to the head of the queue
    reg [1:0] tail; // Pointer to the tail of the queue
    reg [2:0] count; // Count of elements in the queue

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 2'b00;
            tail <= 2'b00;
            count <= 3'b000;
            empty <= 1'b1;
        end else begin
            if (wr_en && count < 4) begin
                fifo[tail] <= data_in;
                tail <= tail + 1'b1;
                count <= count + 1'b1;
                empty <= 1'b0;
            end
            if (rd_en && count > 0) begin
                data_out <= fifo[head];
                head <= head + 1'b1;
                count <= count - 1'b1;
                if (count == 1) empty <= 1'b1;
            end
        end
    end
endmodule