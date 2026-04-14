module dff_sr (
    input D,
    input CLK,
    input SET_B,
    input RESET_B,
    output reg Q,
    output reg Q_N
);

always @ (posedge CLK) begin
    if (SET_B == 0) begin
        Q <= 1;
        Q_N <= 0;
    end else if (RESET_B == 0) begin
        Q <= 0;
        Q_N <= 1;
    end else begin
        Q <= D;
        Q_N <= ~D;
    end
end

endmodule