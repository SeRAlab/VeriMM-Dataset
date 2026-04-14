module sr_latch (
    input wire S,
    input wire R,
    output reg Q,
    output reg Qb
);
    always @ (S, R) begin
        if (S && !R) begin
            Q = 1;
            Qb = 0;
        end else if (!S && R) begin
            Q = 0;
            Qb = 1;
        end else if (!S && !R) begin
            // Hold state
            Q = Q;
            Qb = Qb;
        end else begin
            // Invalid state (S=1, R=1)
            Q = 1'bx; // or you can define a behavior for this case
            Qb = 1'bx;
        end
    end
endmodule