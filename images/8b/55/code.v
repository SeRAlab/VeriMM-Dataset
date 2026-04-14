module top_module(
    input D,
    input SET_B,
    input CLK,
    input VPWR,
    input VGND,
    output reg Q  // Change output Q to output reg
);always @(posedge CLK) begin
    if (SET_B) begin
        Q <= 1;
    end else begin
        Q <= D;
    end
end

endmodule