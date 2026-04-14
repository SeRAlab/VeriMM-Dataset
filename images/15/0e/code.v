module SR_latch (
    input S,
    input R,
    output reg Q,
    output Qn
);
    assign Qn = ~Q;

    always @(S, R) begin
        if (S && ~R)
            Q <= 1; // Set
        else if (~S && R)
            Q <= 0; // Reset
        // If both S and R are low, Q retains its state
    end
endmodule