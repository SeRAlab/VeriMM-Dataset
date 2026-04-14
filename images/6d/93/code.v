module top_module (
    input [3:1] z,
    input h,
    output reg Z2,
    output reg Z3
);

    always @(*) begin
        // Z2 corresponds to the transition to state S
        Z2 = (z[1] & ~h) | (z[3] & ~h);

        // Z3 corresponds to the transition to state T
        Z3 = (z[1] & h) | (z[2] & h);
    end

endmodule