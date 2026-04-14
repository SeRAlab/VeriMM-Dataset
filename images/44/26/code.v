module top_module(
    aclr,
    clock,
    data,
    rdreq,
    wrreq,
    empty,
    full,
    almost_full,
    q,
    usedw
);parameter WIDTH = 8;
    parameter DEPTH = 16;

    input aclr, clock, rdreq, wrreq;
    input [WIDTH-1:0] data;

    output empty, full, almost_full;
    output [WIDTH-1:0] q;
    output [3:0] usedw;

    reg [WIDTH-1:0] mem [DEPTH-1:0];
    reg [4:0] head, tail, count;
    reg [4:0] next_head, next_tail, next_count;  // Change wire to reg

    assign empty = (count == 0);
    assign full = (count == DEPTH);
    assign almost_full = (count >= DEPTH*7/8);
    assign q = mem[tail];

    always @(posedge clock) begin
        if (aclr) begin
            head <= 0;
            tail <= 0;
            count <= 0;
        end else begin
            head <= next_head;
            tail <= next_tail;
            count <= next_count;
        end
    end

    always @* begin
        next_head = head;
        next_tail = tail;
        next_count = count;

        if (wrreq && !full) begin
            mem[head] <= data;
            next_head = head + 1;
            if (next_head == DEPTH) next_head = 0;
            next_count = count + 1;
        end

        if (rdreq && !empty) begin
            next_tail = tail + 1;
            if (next_tail == DEPTH) next_tail = 0;
            next_count = count - 1;
        end
    end

    assign usedw = count;

endmodule