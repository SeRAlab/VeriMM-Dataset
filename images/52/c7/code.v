module top_module(
    input clock,
    input [98:0] data,
    input rdreq,
    input wrreq,
    output empty,
    output full,
    output [98:0] q,
    output reg [6:0] usedw
);reg [98:0] fifo [0:98];
    reg [6:0] read_addr;
    reg [6:0] write_addr;
    reg [6:0] next_write_addr;
    reg [6:0] usedw_reg;
    wire [6:0] usedw_wire;
    reg [98:0] q_reg;
    wire [98:0] q_wire;
    reg empty_reg;
    reg full_reg;
    wire empty_wire;
    wire full_wire;

    assign usedw_wire = usedw_reg;
    assign q_wire = q_reg;
    assign empty_wire = empty_reg;
    assign full_wire = full_reg;

    always @(posedge clock) begin
        if (wrreq && !full_reg) begin
            fifo[write_addr] <= data;
            next_write_addr <= write_addr + 1;
        end else begin
            next_write_addr <= write_addr;
        end

        if (rdreq && !empty_reg) begin
            q_reg <= fifo[read_addr];
            read_addr <= read_addr + 1;
        end

        usedw_reg <= next_write_addr - read_addr;
        write_addr <= next_write_addr;

        empty_reg <= (usedw_reg == 0);
        full_reg <= (usedw_reg == 99);
    end

    assign usedw = usedw_wire;
    assign q = q_wire;
    assign empty = empty_wire;
    assign full = full_wire;

endmodule