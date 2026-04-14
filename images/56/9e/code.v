module top_module(
    clock,
    data,
    rdreq,
    wrreq,
    empty,
    full,
    q,
    usedw
);input clock;
input [15:0] data;
input rdreq;
input wrreq;
output empty;
output full;
output reg [15:0] q;  // changed to reg
output [7:0] usedw;

reg [15:0] fifo[0:255];
reg [7:0] usedw_reg;
assign usedw = usedw_reg;  // corrected the assignment here
wire empty;
wire full;

integer head = 0;
integer tail = 0;

always @(posedge clock) begin
    if (wrreq && !full) begin
        fifo[head] <= data;
        head <= (head == 255) ? 0 : head + 1;
        usedw_reg <= usedw_reg + 1;
    end
    if (rdreq && !empty) begin
        q <= fifo[tail];
        tail <= (tail == 255) ? 0 : tail + 1;
        usedw_reg <= usedw_reg - 1;
    end
end

assign empty = (head == tail) ? 1 : 0;
assign full = ((head + 1) % 256 == tail) ? 1 : 0;

endmodule