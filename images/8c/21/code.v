module top_module (
    input [3:1] w,
    input e,
    output reg W2,
    output reg W3
);

    always @(*) begin
        // W2 corresponds to the transition to state Z
        W2 = (w[1] & ~e) | (w[3] & e);

        // W3 corresponds to the transition to state A
        W3 = (w[1] & e) | (w[2] & e);
    end

endmodule