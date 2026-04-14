module top_module(
    input D,
    input CLK_N,
    input SET_B,
    input RESET_B,
    output reg Q,  // Changed to 'output reg Q' to support procedural assignment
    output Q_N
);assign Q_N = ~Q;

    always @(posedge CLK_N) begin
        if (SET_B == 0) begin
            Q <= 1;
        end else if (RESET_B == 0) begin
            Q <= 0;
        end else begin
            Q <= D;
        end
    end

endmodule