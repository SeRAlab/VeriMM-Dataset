module top_module(
    aclr,
    data,
    rdclk,
    rdreq,
    wrclk,
    wrreq,
    q,
    rdempty,
    wrempty,
    wrusedw
);input aclr;
    input [180:0] data;
    input rdclk;
    input rdreq;
    input wrclk;
    input wrreq;
    output reg [180:0] q;  // Changed from wire to reg
    output rdempty;
    output wrempty;
    output [6:0] wrusedw;

    reg [180:0] fifo [0:127];
    reg [6:0] wrptr;
    reg [6:0] rdptr;
    wire [7:0] usedw;

    assign wrusedw = usedw - 1;
    assign rdempty = (wrptr == rdptr);
    assign wrempty = (usedw == 0);

    always @(posedge wrclk) begin
        if (aclr) begin
            wrptr <= 0;
        end else if (wrreq && !wrempty) begin  // Check wrempty before writing
            fifo[wrptr] <= data;
            wrptr <= wrptr + 1;
        end
    end

    always @(posedge rdclk) begin
        if (rdreq && !rdempty) begin
            q <= fifo[rdptr];
            rdptr <= rdptr + 1;
        end
    end

    assign usedw = (wrptr > rdptr) ? (wrptr - rdptr) : (128 + wrptr - rdptr);

endmodule