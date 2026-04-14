module digital_circuit (
    input D,
    input SET_B,
    input CLK,
    input VPWR,
    input VGND,
    output Q
);

reg Q;

always @(posedge CLK) begin
    if (SET_B) begin
        Q <= 1;
    end else begin
        Q <= D;
    end
end

endmodule