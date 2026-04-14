module top_module (
    input [3:1] s,
    input c,
    output reg S2,
    output reg S3
);

    always @(*) begin
        // S2 corresponds to the transition to state Q
        S2 = (s[1] & ~c) | (s[3] & c);

        // S3 corresponds to the transition to state R
        S3 = (s[1] & c) | (s[2] & c);
    end

endmodule