module top_module(
    input in,
    input clock,
    input enable_l,
    input reset,
    input clear,
    output reg out
);reg q1, q2, q3, q4;

    always @(posedge clock) begin
        if (enable_l == 0) begin
            q1 <= in;
            q2 <= q1;
            q3 <= q2;
            q4 <= q3;
        end
    end

    always @(*) begin
        if (reset == 1) begin
            out <= 0;
        end else if (clear == 1) begin
            out <= 1;
        end else if (q4 == 1 && q3 == 0 && q2 == 1 && q1 == 0) begin
            out <= 0;
        end else if (q4 == 0 && q3 == 1 && q2 == 0 && q1 == 1) begin
            out <= 1;
        end else begin
            out <= q4;
        end
    end

endmodule