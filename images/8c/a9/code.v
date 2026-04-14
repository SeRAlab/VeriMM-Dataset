module top_module(
    input [30:0] data,
    input wrreq,
    input rdreq,
    input clock,
    input aclr,
    output reg [30:0] q,  // Changed from wire to reg
    output full,
    output empty,
    output [6:0] usedw,
    output almost_full
);parameter DEPTH = 128;
    parameter WIDTH = 31;

    reg [WIDTH-1:0] mem [DEPTH-1:0];
    reg [6:0] usedw_reg;
    reg full_reg;
    reg empty_reg;
    reg almost_full_reg;

    integer wr_ptr_reg;
    integer rd_ptr_reg;

    always @(posedge clock) begin
        if (aclr) begin
            wr_ptr_reg <= 0;
            rd_ptr_reg <= 0;
            usedw_reg <= 0;
            full_reg <= 0;
            empty_reg <= 1;
            almost_full_reg <= 0;
            q <= 0; // Initialize q
        end else begin
            if (wrreq && !full_reg) begin
                mem[wr_ptr_reg] <= data;
                wr_ptr_reg <= wr_ptr_reg + 1;
                usedw_reg <= usedw_reg + 1;
                if (wr_ptr_reg == DEPTH-1) wr_ptr_reg <= 0;
                if (usedw_reg == DEPTH) full_reg <= 1;
                if (usedw_reg >= DEPTH-8) almost_full_reg <= 1;
                empty_reg <= 0;
            end
            if (rdreq && !empty_reg) begin
                q <= mem[rd_ptr_reg];
                rd_ptr_reg <= rd_ptr_reg + 1;
                usedw_reg <= usedw_reg - 1;
                if (rd_ptr_reg == DEPTH-1) rd_ptr_reg <= 0;
                if (usedw_reg == 1) empty_reg <= 1;
                if (usedw_reg <= 8) almost_full_reg <= 0;
                full_reg <= 0;
            end
        end
    end

    assign usedw = usedw_reg;
    assign full = full_reg;
    assign empty = empty_reg;
    assign almost_full = almost_full_reg;

endmodule