module fifo_queue (
    input wire clk,
    input wire rst,
    input wire enq,
    input wire deq,
    input wire [3:0] data_in,
    output reg [3:0] data_out,
    output reg full,
    output reg empty
);
    reg [3:0] fifo [7:0]; // 8 entries of 4 bits each
    reg [2:0] head, tail; // pointers for head and tail
    reg [3:0] count; // current count of items in FIFO

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            head <= 3'b0;
            tail <= 3'b0;
            count <= 4'b0;
            full <= 1'b0;
            empty <= 1'b1;
        end else begin
            if (enq && !full) begin
                fifo[tail] <= data_in;
                tail <= (tail + 1) % 8;
                count <= count + 1;
            end
            if (deq && !empty) begin
                data_out <= fifo[head];
                head <= (head + 1) % 8;
                count <= count - 1;
            end
            full <= (count == 4'b1000);
            empty <= (count == 4'b0000);
        end
    end
endmodule