module top_module (
    input [3:1] s,
    input h,
    output reg S2,
    output reg S3
);

    always @(*) begin
        // S2 corresponds to the transition to state V
        S2 = (s[1] & ~h) | (s[3] & h);

        // S3 corresponds to the transition to state W
        S3 = (s[1] & h) | (s[2] & h);
    end

endmodule