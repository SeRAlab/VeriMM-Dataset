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
    reg [8:0] head;
    reg [8:0] tail;
    reg [8:0] next_head;  // Changed to reg
    reg [8:0] next_tail;  // Changed to reg
    wire [8:0] usedw;
    wire [32:0] q;
    wire empty;

    assign usedw = head >= tail ? head - tail : head - tail + 512;
    assign q = fifo[tail];
    assign empty = head == tail;

    always @(posedge clock) begin
        if (aclr) begin
            head <= 0;
            tail <= 0;
        end else begin
            head <= next_head;
            tail <= next_tail;
        end
    end

    always @* begin
        next_head = head;
        next_tail = tail;

        if (wrreq && usedw < 512) begin
            fifo[head] <= data;
            next_head = head + 1;
        end

        if (rdreq && !empty) begin
            next_tail = tail + 1;
        end
    end

endmodule