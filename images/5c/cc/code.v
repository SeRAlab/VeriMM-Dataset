module top_module (
    input [3:1] s,
    input g,
    output reg S2,
    output reg S3
);

    always @(*) begin
        // S2 corresponds to the transition to state E
        S2 = (s[1] & ~g) | (s[3] & g);

        // S3 corresponds to the transition to state F
        S3 = (s[1] & g) | (s[2] & g);
    end

endmodule