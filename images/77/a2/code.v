module top_module (
    input [3:1] u,
    input c,
    output reg U2,
    output reg U3
);

    always @(*) begin
        // U2 corresponds to the transition to state N
        U2 = (u[1] & ~c) | (u[3] & ~c);

        // U3 corresponds to the transition to state O
        U3 = (u[1] & c) | (u[2] & c);
    end

endmodule