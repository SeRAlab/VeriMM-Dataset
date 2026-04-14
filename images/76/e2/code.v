module top_module(
    input CLK,
    input D,
    input RESET_B,
    input SET_B,
    input CTRL,
    output reg Q,
    output reg Q_N
);always @(posedge CLK, negedge CTRL) begin
        if (CTRL) begin
            Q <= D;
            Q_N <= ~D;
        end else begin
            Q <= Q;
            Q_N <= Q_N;
        end
    end

    always @(posedge CLK, negedge RESET_B, negedge SET_B) begin
        if (!RESET_B) begin
            Q <= 1'b0;
            Q_N <= 1'b1;
        end else if (!SET_B) begin
            Q <= 1'b1;
            Q_N <= 1'b0;
        end else begin
            Q <= Q;
            Q_N <= Q_N;
        end
    end

endmodule