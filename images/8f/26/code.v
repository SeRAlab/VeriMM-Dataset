module top_module(
    input CLK,
    input D,
    input EN,
    output reg Q,
    output reg Q_N
);always @(posedge CLK) begin
        if (EN) begin
            Q <= D;
            Q_N <= ~D;
        end
        else begin
            Q <= Q;
            Q_N <= Q_N;
        end
    end

endmodule