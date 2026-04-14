module top_module(
    input D, CLK, SET, RESET,
    output reg Q, Q_N
);always @(posedge CLK or posedge SET or posedge RESET) begin
    if (SET) begin
        Q <= 1'b1;
    end else if (RESET) begin
        Q <= 1'b0;
    end else begin
        Q <= D;
    end
end

assign Q_N = ~Q;

endmodule