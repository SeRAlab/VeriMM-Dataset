module top_module (
    input [3:1] v,
    input d,
    output reg V2,
    output reg V3
);

    always @(*) begin
        // V2 corresponds to the transition to state E
        V2 = (v[1] & ~d) | (v[3] & d);

        // V3 corresponds to the transition to state F
        V3 = (v[1] & d) | (v[2] & ~d);
    end

endmodule