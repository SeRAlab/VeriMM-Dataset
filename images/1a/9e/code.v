module FIFO #(parameter WIDTH = 8, parameter DEPTH = 16) (
    input clk,
    input rst,
    input enqueue,
    input dequeue,
    input [WIDTH-1:0] data_in,
    output reg [WIDTH-1:0] data_out,
    output reg full,
    output reg empty
);

reg [WIDTH-1:0] fifo_mem [0:DEPTH-1];
reg [4:0] head, tail; // 5 bits to address up to 32 entries

always @(posedge clk or posedge rst) begin
    if (rst) begin
        head <= 0;
        tail <= 0;
        full <= 0;
        empty <= 1;
    end else begin
        if (enqueue && !full) begin
            fifo_mem[tail] <= data_in;
            tail <= (tail + 1) % DEPTH;
            empty <= 0;
            if (tail + 1 == head) full <= 1;
        end
        
        if (dequeue && !empty) begin
            data_out <= fifo_mem[head];
            head <= (head + 1) % DEPTH;
            full <= 0;
            if (head == tail) empty <= 1;
        end
    end
end

endmodule