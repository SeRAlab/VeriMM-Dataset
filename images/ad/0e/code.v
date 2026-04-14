module top_module (
    input [3:1] s,
    input k,
    output reg S2,
    output reg S3
);

    always @(*) begin
        // S2 corresponds to the transition to state X
        S2 = (s[1] & ~k) | (s[3] & k);

        // S3 corresponds to the transition to state Y
        S3 = (s[1] & k) | (s[2] & k);
    end

endmodule