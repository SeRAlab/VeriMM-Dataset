module top_module(
    aclr,
    clock,
    data,
    rdreq,
    wrreq,
    almost_full,
    empty,
    full,
    q
);input aclr;
input clock;
input [71:0] data;
input rdreq;
input wrreq;
output almost_full;
output empty;
output full;
output reg [71:0] q; // Change to reg type since it's assigned in always block.

reg [71:0] fifo [0:255];
reg [7:0] read_ptr = 0;
reg [7:0] write_ptr = 0;
wire [7:0] count = write_ptr - read_ptr;

assign almost_full = (count == 255);
assign empty = (count == 0);
assign full = (count == 255);

always @(posedge clock) begin
    if (aclr) begin
        read_ptr <= 0;
        write_ptr <= 0;
        fifo[0] <= 0;
        q <= 0; // Reset q as well during async clear
    end else begin
        if (rdreq && !empty) begin
            q <= fifo[read_ptr];
            read_ptr <= read_ptr + 1;
        end
        if (wrreq && !full) begin
            fifo[write_ptr] <= data;
            write_ptr <= write_ptr + 1;
        end
    end
end

endmodule