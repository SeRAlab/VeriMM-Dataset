module fifo_queue (
    input clk,
    input rst,
    input [3:0] data_in,
    input we,
    input re,
    output reg [3:0] data_out,
    output reg empty,
    output reg full
);
    reg [3:0] fifo [3:0];
    reg [1:0] head, tail;
    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 2'b00;
            tail <= 2'b00;
            count <= 4'b0000;
            empty <= 1'b1;
            full <= 1'b0;
        end else begin
            if (we && !full) begin
                fifo[tail] <= data_in;
                tail <= (tail + 1) % 4;
                count <= count + 1;
            end
            if (re && !empty) begin
                data_out <= fifo[head];
                head <= (head + 1) % 4;
                count <= count - 1;
            end
            empty <= (count == 0);
            full <= (count == 4);
        end
    end
endmodule