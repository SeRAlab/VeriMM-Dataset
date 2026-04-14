module sr_latch (
    input wire S,
    input wire R,
    output reg Q,
    output reg Qn
);
    always @(S, R) begin
        if (S && !R) begin
            Q <= 1;
            Qn <= 0;
        end else if (!S && R) begin
            Q <= 0;
            Qn <= 1;
        end
        // State remains unchanged if both S and R are low or both are high
    end
endmodule