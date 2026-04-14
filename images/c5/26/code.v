module flipflop_preset_clear(
    input CLK,
    input D,
    input PRE,
    input CLR,
    output reg Q,
    output reg Q_bar
);

always @ (posedge CLK) begin
    if (PRE) begin
        Q <= 1'b1;
    end else if (CLR) begin
        Q <= 1'b0;
    end else begin
        Q <= D;
    end
end

assign Q_bar = ~Q;

endmodule