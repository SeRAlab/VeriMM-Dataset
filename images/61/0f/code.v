module top_module(
    input clock,
    input [13:0] data,
    input rdreq,
    input wrreq,
    output almost_full,
    output empty,
    output full,
    output reg [13:0] q,  // Changed from wire to reg
    output [7:0] usedw
);reg [13:0] fifo_mem [0:255];
    reg [7:0] fifo_count = 0;
    reg [7:0] fifo_head = 0;
    reg [7:0] fifo_tail = 0;
    
    assign usedw = fifo_count;
    assign empty = (fifo_count == 0);
    assign full = (fifo_count == 256);
    assign almost_full = (fifo_count >= 240);
    
    always @(posedge clock) begin
        if (wrreq && !full) begin
            fifo_mem[fifo_head] <= data;
            fifo_head <= fifo_head + 1;
            fifo_count <= fifo_count + 1;
            if (fifo_head == 256) begin
                fifo_head <= 0;
            end
        end
        if (rdreq && !empty) begin
            q <= fifo_mem[fifo_tail];
            fifo_tail <= fifo_tail + 1;
            fifo_count <= fifo_count - 1;
            if (fifo_tail == 256) begin
                fifo_tail <= 0;
            end
        end
    end
    
endmodule