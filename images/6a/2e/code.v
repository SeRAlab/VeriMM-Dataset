module top_module(
    input CLK,
    input D,
    input RESET_N,
    input ENABLE,
    output reg Q,
    output reg Q_N
);always @(posedge CLK or negedge RESET_N) begin
    if (~RESET_N) begin
        Q <= 0;
    end else if (ENABLE) begin
        Q <= D;
    end
end

assign Q_N = ~Q;

endmodule