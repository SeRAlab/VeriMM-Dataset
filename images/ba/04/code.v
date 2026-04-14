module top_module(
    output reg Q,
    output reg Q_N,
    input D,
    input CLK_N,
    input SET_B,
    input RESET_B
);always @(posedge CLK_N or negedge SET_B or negedge RESET_B) begin
        if (!SET_B) begin
            Q <= 1;
            Q_N <= 0;
        end else if (!RESET_B) begin
            Q <= 0;
            Q_N <= 1;
        end else begin
            Q <= D;
            Q_N <= ~D;
        end
    end

endmodule