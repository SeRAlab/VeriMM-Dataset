module top_module(
    aclr,
    clock,
    data,
    rdreq,
    wrreq,
    empty,
    q,
    usedw
);input aclr;
    input clock;
    input [32:0] data;
    input rdreq;
    input wrreq;
    output empty;
    output [32:0] q;
    output [8:0] usedw;

    reg [32:0] fifo [0:511];
    reg [8:0] usedw_reg;
    reg [8:0] rd_ptr;
    reg [8:0] wr_ptr;
    wire [8:0] usedw = usedw_reg;
    wire empty = (usedw == 0);
    wire [32:0] q = fifo[rd_ptr];
    
    always @(posedge clock) begin
        if (aclr) begin
            usedw_reg <= 0;
            rd_ptr <= 0;
            wr_ptr <= 0;
        end else begin
            if (wrreq && (usedw_reg < 512)) begin
                fifo[wr_ptr] <= data;
                usedw_reg <= usedw_reg + 1;
                wr_ptr <= wr_ptr + 1;
            end
            if (rdreq && (usedw_reg > 0)) begin
                rd_ptr <= rd_ptr + 1;
                usedw_reg <= usedw_reg - 1;
            end
        end
    end

endmodule