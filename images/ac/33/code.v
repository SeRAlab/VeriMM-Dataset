module top_module(
    aclr,
    clock,
    data,
    rdreq,
    wrreq,
    empty,
    full,
    q,
    usedw
);input aclr;
input clock;
input [29:0] data;
input rdreq;
input wrreq;
output empty;
output full;
output [29:0] q;
output [4:0] usedw;

reg [29:0] mem [31:0];
reg [4:0] usedw_reg;
reg empty_reg;
reg full_reg;
reg [29:0] q_reg;
reg [4:0] write_ptr_reg;
reg [4:0] read_ptr_reg;

always @(posedge clock) begin
    if (aclr == 1'b0) begin
        // Asynchronous clear
        empty_reg <= 1'b1;
        full_reg <= 1'b0;
        usedw_reg <= 5'b00000;
        q_reg <= 30'b0;
        write_ptr_reg <= 5'b00000;
        read_ptr_reg <= 5'b00000;
    end else begin
        // Write operation
        if (wrreq == 1'b1 && full_reg == 1'b0) begin
            mem[write_ptr_reg] <= data;
            write_ptr_reg <= write_ptr_reg + 1;
            usedw_reg <= usedw_reg + 1;
            if (write_ptr_reg == 5'b11111) begin
                write_ptr_reg <= 5'b00000;
            end
            if (usedw_reg == 5'b10000) begin
                full_reg <= 1'b1;
            end
            empty_reg <= 1'b0;
        end
        // Read operation
        if (rdreq == 1'b1 && empty_reg == 1'b0) begin
            q_reg <= mem[read_ptr_reg];
            read_ptr_reg <= read_ptr_reg + 1;
            usedw_reg <= usedw_reg - 1;
            if (read_ptr_reg == 5'b11111) begin
                read_ptr_reg <= 5'b00000;
            end
            if (usedw_reg == 5'b00000) begin
                empty_reg <= 1'b1;
            end
            full_reg <= 1'b0;
        end
    end
end

assign empty = empty_reg;
assign full = full_reg;
assign q = q_reg;
assign usedw = usedw_reg;

endmodule