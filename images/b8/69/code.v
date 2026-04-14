module top_module (
    input [3:1] s,
    input b,
    output reg S2,
    output reg S3
);

    always @(*) begin
        // S2 corresponds to the transition to state B
        S2 = (s[1] & ~b) | (s[3] & b);

        // S3 corresponds to the transition to state C
        S3 = (s[1] & b) | (s[2] & ~b);
    end

endmodule