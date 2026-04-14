module FIFO_Queue (
    input wire clk,
    input wire reset,
    input wire enqueue,
    input wire dequeue,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg full,
    output reg empty
);
    reg [7:0] queue [3:0]; // 4-element FIFO queue
    reg [1:0] head, tail, count; // head and tail pointers, count of items

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 2'b00;
            tail <= 2'b00;
            count <= 2'b00;
            full <= 1'b0;
            empty <= 1'b1;
        end else begin
            if (enqueue && !full) begin
                queue[tail] <= data_in;
                tail <= tail + 1'b1;
                count <= count + 1'b1;
            end
            if (dequeue && !empty) begin
                data_out <= queue[head];
                head <= head + 1'b1;
                count <= count - 1'b1;
            end
            full <= (count == 2'b11);
            empty <= (count == 2'b00);
        end
    end
endmodule