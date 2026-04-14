module fifo_queue(
    input clk,
    input reset,
    input enqueue,
    input dequeue,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    reg [7:0] fifo_memory [7:0]; // 8-depth FIFO
    reg [2:0] head, tail, count; // Head, tail, and count of elements

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 3'b000;
            tail <= 3'b000;
            count <= 3'b000;
            full <= 1'b0;
            empty <= 1'b1;
            data_out <= 8'b0;
        end else begin
            if (enqueue && !full) begin
                fifo_memory[tail] <= data_in;
                tail <= (tail + 1) % 8;
                count <= count + 1;
            end
            
            if (dequeue && !empty) begin
                data_out <= fifo_memory[head];
                head <= (head + 1) % 8;
                count <= count - 1;
            end
            
            full <= (count == 3'b111); // 8 items in FIFO
            empty <= (count == 3'b000); // 0 items in FIFO
        end
    end
endmodule