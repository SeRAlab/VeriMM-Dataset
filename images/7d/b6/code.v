module top_module(
    input D,
    input CLK,
    input RESET,
    input PRESET,
    output reg Q,
    output reg Q_BAR
);always @(posedge CLK) begin
        if (RESET) begin
            Q <= 1'b0;
            Q_BAR <= 1'b1;
        end else if (PRESET) begin
            Q <= 1'b1;
            Q_BAR <= 1'b0;
        end else begin
            Q <= D;
            Q_BAR <= ~D;
        end
    end

endmodule