module top_module(
    input rst,
    input clk,
    input push,
    input pop,
    input [7:0] d,
    output reg [7:0] q,
    output reg full,
    output reg empty,
    output reg [3:0] count,
    output reg almost_empty,
    output reg almost_full
);reg [7:0] fifo [15:0];
reg [3:0] head;
reg [3:0] tail;
reg [3:0] next_head;
reg [3:0] next_tail;

always @(posedge clk) begin
    if (rst) begin
        head <= 4'b0;
        tail <= 4'b0;
        full <= 1'b0;
        empty <= 1'b1;
        count <= 4'b0;
        almost_empty <= 1'b0;
        almost_full <= 1'b0;
    end else begin
        next_head = head;
        next_tail = tail;
        if (push && !full) begin
            fifo[head] <= d;
            next_head = (head == 15) ? 4'b0 : head + 4'b1;
        end
        if (pop && !empty) begin
            q <= fifo[tail];
            next_tail = (tail == 15) ? 4'b0 : tail + 4'b1;
        end
        full <= (count == 4'b1111);
        empty <= (count == 4'b0000);
        count <= (push && !pop && !full) ? count + 4'b1 :
                 (!push && pop && !empty) ? count - 4'b1 :
                 count;
        almost_empty <= (count == 4'b0001);
        almost_full <= (count == 4'b1110);
        head <= next_head;
        tail <= next_tail;
    end
end

endmodule