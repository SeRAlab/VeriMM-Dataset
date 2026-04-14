module fifo_queue #(parameter SIZE = 4) (
    input clk,
    input rst,
    input [7:0] data_in,
    input enqueue,
    input dequeue,
    output reg [7:0] data_out,
    output reg empty,
    output reg full
);
    reg [7:0] queue[0:SIZE-1];
    reg [3:0] head, tail, count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            empty <= 1;
            full <= 0;
            data_out <= 0;
        end else begin
            if (enqueue && !full) begin
                queue[tail] <= data_in;
                tail <= (tail + 1) % SIZE;
                count <= count + 1;
            end
            if (dequeue && !empty) begin
                data_out <= queue[head];
                head <= (head + 1) % SIZE;
                count <= count - 1;
            end

            empty <= (count == 0);
            full <= (count == SIZE);
        end
    end
endmodule