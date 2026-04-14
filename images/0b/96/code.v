module sr_latch (
    input wire S,
    input wire R,
    output reg Q,
    output reg Qn
);
    always @ (S or R) begin
        if (S && ~R) begin
            Q <= 1;
            Qn <= 0;
        end else if (~S && R) begin
            Q <= 0;
            Qn <= 1;
        end else if (~S && ~R) begin
            // retain previous state
            Q <= Q;
            Qn <= Qn;
        end else begin
            // invalid state, hold previous state
            Q <= Q;
            Qn <= Qn;
        end
    end
endmodule