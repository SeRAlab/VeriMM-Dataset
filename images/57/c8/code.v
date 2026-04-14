module top_module(
    input D,
    input CLK,
    input RESET_N,
    output reg Q,
    output reg Q_N
);always @(posedge CLK or negedge RESET_N) begin
    if (!RESET_N) begin
        Q <= 1'b0;
        Q_N <= 1'b1;
    end else begin
        Q <= D;
        Q_N <= ~D;
    end
end

endmodule