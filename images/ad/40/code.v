module top_module (
    input [4:1] t,
    input b,
    output reg T2,
    output reg T4
);

    always @(*) begin
        // T2 corresponds to the transition to state Q
        T2 = (t[1] & ~b) | (t[3] & ~b);

        // T4 corresponds to the transition to state S
        T4 = (t[2] & b) | (t[4] & ~b);
    end

endmodule