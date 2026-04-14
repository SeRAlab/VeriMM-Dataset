module top_module(
    input CLK,
    input D,
    input RESET,
    input PRESET,
    output reg Q,    // Changed to output reg
    output reg Q_N   // Changed to output reg
);always @(posedge CLK) begin
        if (RESET) begin
            Q <= 1'b0;
            Q_N <= 1'b1;
        end else if (PRESET) begin
            Q <= 1'b1;
            Q_N <= 1'b0;
        end else begin
            Q <= D;
            Q_N <= ~D;
        end
    end

endmodule