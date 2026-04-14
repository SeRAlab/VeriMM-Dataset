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
    reg [7:0] queue [3:0];
    reg [1:0] head, tail, count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 2'b00;
            tail <= 2'b00;
            count <= 2'b00;
            full <= 1'b0;
            empty <= 1'b1;
            data_out <= 8'b0;
        end else begin
            if (enqueue && !full) begin
                queue[tail] <= data_in;
                tail <= (tail + 1) % 4;
                count <= count + 1;
            end
            if (dequeue && !empty) begin
                data_out <= queue[head];
                head <= (head + 1) % 4;
                count <= count - 1;
            end
            full <= (count == 2'b11);
            empty <= (count == 2'b00);
        end
    end
endmodule