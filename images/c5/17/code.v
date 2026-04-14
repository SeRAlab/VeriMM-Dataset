module flip_flop (
    input D,
    output Q,
    input CLK,
    input VPWR,
    input VGND
);

wire Q_bar;
assign Q_bar = ~Q;

// D flip-flop implementation
always @(posedge CLK) begin
    Q <= D;
end

// Reset implementation
always @(posedge VPWR) begin
    Q <= 1'b0;
end

// Power-on reset implementation
always @(negedge VGND) begin
    Q <= 1'b0;
end

endmodule