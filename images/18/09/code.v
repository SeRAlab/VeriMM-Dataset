module sr_latch (
    input wire S,
    input wire R,
    output reg Q,
    output reg Q_not
);
    always @ (S or R) begin
        if (S && ~R) begin
            Q <= 1'b1;
            Q_not <= 1'b0;
        end else if (~S && R) begin
            Q <= 1'b0;
            Q_not <= 1'b1;
        end else if (~S && ~R) begin
            // retain previous state
            Q <= Q;
            Q_not <= Q_not;
        end
    end
endmodule