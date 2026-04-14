module top_module(clk, rst, din, write, read, dout, empty, full);input clk, rst, write, read;
input [15:0] din;
output reg [15:0] dout; // Changed to reg since dout is assigned in always block
output empty, full;

parameter DEPTH = 8;
parameter MAX_COUNT = DEPTH - 1;

reg [15:0] fifo_mem [0:MAX_COUNT];
reg [(DEPTH-1):0] head, tail, count;

assign empty = (count == 0);
assign full = (count == DEPTH);

always @(posedge clk) begin
    if (rst) begin
        head <= 0;
        tail <= 0;
        count <= 0;
        dout <= 0; // Initialize dout on reset
    end else begin
        if (write && !full) begin
            fifo_mem[head] <= din;
            head <= (head == MAX_COUNT) ? 0 : head + 1;
            count <= count + 1;
        end
        if (read && !empty) begin
            dout <= fifo_mem[tail];
            tail <= (tail == MAX_COUNT) ? 0 : tail + 1;
            count <= count - 1;
        end
    end
end

endmodule