module top_module(
    input D,
    input SCD,
    input SCE,
    input CLK,
    output reg Q,
    output reg Q_N
);always @(posedge CLK) begin
        if (SCD) begin
            Q <= 0;
            Q_N <= 1;
        end
        else if (SCE) begin
            Q <= Q;
            Q_N <= ~Q;
        end
        else begin
            Q <= D;
            Q_N <= ~D;
        end
    end

endmodule