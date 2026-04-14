module top_module (
    input [3:1] s,
    input i,
    output reg S2,
    output reg S3
);

    always @(*) begin
        // S2 corresponds to the transition to state S
        S2 = (s[1] & ~i) | (s[3] & i);

        // S3 corresponds to the transition to state T
        S3 = (s[1] & i) | (s[2] & ~i);
    end

endmodule