module d_flip_flop (
    input wire D,
    input wire CLK,
    output reg Q
);
    always @(posedge CLK) begin
        Q <= D;
    end
endmodule