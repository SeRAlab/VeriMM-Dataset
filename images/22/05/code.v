module fifo_queue (
    input clk,
    input reset,
    input push,
    input pop,
    input [3:0] data_in,
    output reg [3:0] data_out,
    output reg full,
    output reg empty,
    output reg [2:0] size
);
    reg [3:0] queue [7:0]; // 8 entries of 4-bit data
    reg [2:0] head, tail, count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
            size <= 0;
        end else begin
            if (push && !full) begin
                queue[tail] <= data_in;
                tail <= (tail + 1) % 8;
                count <= count + 1;
            end
            if (pop && !empty) begin
                data_out <= queue[head];
                head <= (head + 1) % 8;
                count <= count - 1;
            end
            full <= (count == 8);
            empty <= (count == 0);
            size <= count;
        end
    end
endmodule