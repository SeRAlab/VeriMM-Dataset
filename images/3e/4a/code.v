module D_latch (
    input wire D,
    input wire CLK,
    output reg Q
);
    always @(posedge CLK) begin
        Q <= D;
    end
endmodule