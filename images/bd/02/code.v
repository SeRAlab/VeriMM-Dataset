module top_module (
    input [3:1] s,
    input e,
    output reg S2,
    output reg S3
);

    always @(*) begin
        // S2 corresponds to the transition to state K
        S2 = (s[1] & ~e) | (s[3] & e);

        // S3 corresponds to the transition to state L
        S3 = (s[1] & e) | (s[2] & ~e);
    end

endmodule