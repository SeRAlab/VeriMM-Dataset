module top_module (
    input [4:1] a,
    input i,
    output reg A2,
    output reg A3
);

    always @(*) begin
        // A2 corresponds to the transition to state Q
        A2 = (a[1] & ~i) | (a[4] & i);

        // A3 corresponds to the transition to state R
        A3 = (a[1] & i) | (a[3] & i);
    end

endmodule