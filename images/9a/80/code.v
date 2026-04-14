module top_module(
    input D,
    input SET_B,
    input RESET_B,
    input CLK,
    output reg Q,
    output reg Q_N
);// Asynchronous set and reset
    always @ (SET_B, RESET_B) begin
        if (!SET_B) begin
            Q <= 1'b1;
            Q_N <= 1'b0;
        end else if (!RESET_B) begin
            Q <= 1'b0;
            Q_N <= 1'b1;
        end
    end

    // Synchronous D flip-flop
    always @ (posedge CLK) begin
        if (SET_B && RESET_B) begin
            Q <= D;
            Q_N <= ~D;
        end
    end

endmodule