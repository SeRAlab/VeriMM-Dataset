module d_ff_with_async_set_clear(
    input CLK,
    input D,
    input SET,
    input CLR,
    output reg Q,
    output reg Q_bar
);

always @(posedge CLK, posedge SET, posedge CLR) begin
    if (SET) begin
        Q <= 1'b1;
        Q_bar <= 1'b0;
    end else if (CLR) begin
        Q <= 1'b0;
        Q_bar <= 1'b1;
    end else begin
        Q <= D;
        Q_bar <= ~D;
    end
end

endmodule