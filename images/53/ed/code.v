module top_module (
    input [3:1] s,
    input f,
    output reg S2,
    output reg S3
);

    always @(*) begin
        // S2 corresponds to the transition to state H
        S2 = (s[1] & ~f) | (s[3] & f);

        // S3 corresponds to the transition to state I
        S3 = (s[1] & f) | (s[2] & ~f);
    end

endmodule