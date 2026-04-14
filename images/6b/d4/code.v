module top_module(
    input CLK,
    input D,
    input SET_B,
    input CLR_B,
    output reg Q,
    output reg Q_N
);always @(posedge CLK) begin
        if (SET_B == 1'b0) begin
            Q <= 1'b1;
            Q_N <= 1'b0;
        end else if (CLR_B == 1'b0) begin
            Q <= 1'b0;
            Q_N <= 1'b1;
        end else begin
            Q <= D;
            Q_N <= ~D;
        end
    end

endmodule