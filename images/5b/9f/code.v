module top_module(
    output reg Q,   // Changed to output reg to avoid re-declaration error
    input  CLK,
    input  D,
    input  DE,
    input  VPWR,
    input  VGND
);// always block that updates Q on the posedge of CLK
    always @(posedge CLK) begin
        if (DE) begin
            Q <= D;
        end
    end

endmodule