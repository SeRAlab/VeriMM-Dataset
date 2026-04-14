module sr_latch (
    input wire S,
    input wire R,
    output reg Q,
    output reg Qn
);
    always @ (S, R) begin
        if (S == 1'b1 && R == 1'b0) begin
            Q <= 1'b1;
            Qn <= 1'b0;
        end else if (S == 1'b0 && R == 1'b1) begin
            Q <= 1'b0;
            Qn <= 1'b1;
        end else if (S == 1'b0 && R == 1'b0) begin
            // Hold state
            Q <= Q;
            Qn <= Qn;
        end else begin
            // Invalid condition (S=1, R=1)
            Q <= 1'bx;
            Qn <= 1'bx;
        end
    end
endmodule