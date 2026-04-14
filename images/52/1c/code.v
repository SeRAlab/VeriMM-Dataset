module top_module (
    input [3:1] x,
    input f,
    output reg X2,
    output reg X3
);

    always @(*) begin
        // X2 corresponds to the transition to state H
        X2 = (x[1] & ~f) | (x[3] & ~f);

        // X3 corresponds to the transition to state I
        X3 = (x[1] & f) | (x[2] & f);
    end

endmodule