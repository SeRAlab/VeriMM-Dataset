module top_module (
    input [3:1] s,
    input a,
    output reg S2,
    output reg S3
);

    always @(*) begin
        // S2 corresponds to the transition to state Y
        S2 = (s[1] & ~a) | (s[3] & a);

        // S3 corresponds to the transition to state Z
        S3 = (s[1] & a) | (s[2] & a);
    end

endmodule