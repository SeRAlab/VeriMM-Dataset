module top_module(
    input CLK,
    input D,
    input RESET_B,
    input SET_B,
    output reg Q,
    output reg Q_N
);always @(posedge CLK, negedge RESET_B, negedge SET_B) begin
        if (!RESET_B) begin
            Q <= 0;
            Q_N <= 1;
        end else if (!SET_B) begin
            Q <= 1;
            Q_N <= 0;
        end else begin
            Q <= D;
            Q_N <= ~D;
        end
    end

endmodule