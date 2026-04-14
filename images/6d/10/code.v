module top_module(
    aclr,
    clock,
    data,
    rdreq,
    wrreq,
    almost_empty,
    empty,
    full,
    q,
    usedw
);parameter FIFO_DEPTH = 1024;
    parameter DATA_WIDTH = 16;
    parameter ADDR_WIDTH = $clog2(FIFO_DEPTH);
    
    input aclr;
    input clock;
    input [DATA_WIDTH-1:0] data;
    input rdreq;
    input wrreq;
    output almost_empty;
    output empty;
    output full;
    output [DATA_WIDTH-1:0] q;
    output [ADDR_WIDTH-1:0] usedw;
    
    reg [ADDR_WIDTH-1:0] head;
    reg [ADDR_WIDTH-1:0] tail;
    reg [ADDR_WIDTH-1:0] usedw_reg;
    reg [DATA_WIDTH-1:0] fifo_mem [0:FIFO_DEPTH-1];
    wire [ADDR_WIDTH-1:0] next_head = (head == FIFO_DEPTH-1) ? 0 : head+1;
    wire [ADDR_WIDTH-1:0] next_tail = (tail == FIFO_DEPTH-1) ? 0 : tail+1;
    
    assign usedw = usedw_reg;
    assign empty = (usedw_reg == 0);
    assign full = (usedw_reg == FIFO_DEPTH);
    assign almost_empty = (usedw_reg <= 1);
    assign q = fifo_mem[tail];
    
    always @(posedge clock) begin
        if (aclr) begin
            head <= 0;
            tail <= 0;
            usedw_reg <= 0;
        end else begin
            if (wrreq && !full) begin
                fifo_mem[head] <= data;
                head <= next_head;
                usedw_reg <= usedw_reg + 1;
            end
            if (rdreq && !empty) begin
                tail <= next_tail;
                usedw_reg <= usedw_reg - 1;
            end
        end
    end
    
endmodule