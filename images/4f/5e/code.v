module top_module(
    input CLK,
    input D,
    input SET,
    input CLR,
    input PRE,
    output reg Q,
    output reg Q_N
);always @(posedge CLK or posedge SET or posedge CLR or posedge PRE) begin
    if (SET) begin
        Q <= 1'b1;
    end else if (CLR) begin
        Q <= 1'b0;
    end else if (PRE) begin
        Q <= 1'b1;
    end else begin
        Q <= D;
    end
end

assign Q_N = ~Q;

endmodule