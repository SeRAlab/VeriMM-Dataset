module top_module(
    input D, CLK, RESET_B, SET_B,
    output reg Q, output reg Q_N
);wire DFF_IN;

    assign DFF_IN = (SET_B & ~RESET_B) ? 1'b1 :
                   (~SET_B & RESET_B) ? 1'b0 :
                   D;

    always @(posedge CLK) begin
        Q <= DFF_IN;
        Q_N <= ~DFF_IN;
    end

endmodule