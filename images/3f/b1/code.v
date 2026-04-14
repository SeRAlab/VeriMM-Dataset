module fifo_queue (
    input clk,
    input rst,
    input enq,
    input deq,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] fifo [0:3]; // FIFO with depth 4
    reg [1:0] head, tail;
    reg [1:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 0;
            tail <= 0;
            count <= 0;
            data_out <= 0;
        end else begin
            if (enq && count < 4) begin
                fifo[tail] <= data_in;
                tail <= (tail + 1) % 4;
                count <= count + 1;
            end
            if (deq && count > 0) begin
                data_out <= fifo[head];
                head <= (head + 1) % 4;
                count <= count - 1;
            end
        end
    end
endmodule