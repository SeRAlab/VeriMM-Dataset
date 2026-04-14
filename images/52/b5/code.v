module top_module(
    input  wire D,
    input  wire CLK,
    input  wire RESET,
    input  wire SET,
    input  wire CE,
    output reg  Q,
    output reg  Q_N
);always @(posedge CLK) begin
        if (RESET) begin
            Q <= 0;
            Q_N <= 1;
        end else if (SET) begin
            Q <= 1;
            Q_N <= 0;
        end else if (CE) begin
            Q <= D;
            Q_N <= ~D;
        end
    end

endmodule