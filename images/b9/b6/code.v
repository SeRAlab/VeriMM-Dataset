module top_module(
    input  D   ,
    output reg Q,   // Changed from net to reg
    input  GATE
);always @(posedge GATE) begin
    Q <= D;
end

endmodule