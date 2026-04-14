module sr_latch (
    input wire S,
    input wire R,
    output reg Q,
    output wire Qn
);
    assign Qn = ~Q;

    always @(S, R) begin
        if (S && !R) 
            Q <= 1; // Set
        else if (!S && R) 
            Q <= 0; // Reset
        // If both S and R are 0, maintain the previous state (Q)
        // If both S and R are 1, the state is undefined, so we do nothing.
    end
endmodule