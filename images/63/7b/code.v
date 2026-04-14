module top_module (
    input [3:1] s,
    input j,
    output reg S2,
    output reg S3
);

    always @(*) begin
        // S2 corresponds to the transition to state R
        S2 = (s[1] & ~j) | (s[3] & j);

        // S3 corresponds to the transition to state S
        S3 = (s[1] & j) | (s[2] & j);
    end

endmodule