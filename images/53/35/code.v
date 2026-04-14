module top_module(
    input clock,
    input [71:0] data,
    input rdreq,
    input sclr,
    input wrreq,
    output empty,
    output full,
    output [71:0] q,
    output [2:0] usedw
);reg [71:0] buffer [0:7];
    reg [2:0] head;
    reg [2:0] tail;
    reg [2:0] next_tail;
    reg [2:0] usedw_reg;
    wire full_reg;
    wire empty_reg;
    
    assign full = full_reg;
    assign empty = empty_reg;
    assign q = buffer[tail];
    assign usedw = usedw_reg;
    
    always @(posedge clock) begin
        if (sclr) begin
            head <= 3'b0;
            tail <= 3'b0;
            next_tail <= 3'b0;
            usedw_reg <= 3'b0;
        end else begin
            if (wrreq && !full_reg) begin
                buffer[head] <= data;
                head <= head + 1;
                usedw_reg <= usedw_reg + 1;
            end
            if (rdreq && !empty_reg) begin
                tail <= next_tail;
                next_tail <= next_tail + 1;
                usedw_reg <= usedw_reg - 1;
            end
        end
    end
    
    assign full_reg = (usedw_reg == 3'b100);
    assign empty_reg = (usedw_reg == 3'b0);

endmodule