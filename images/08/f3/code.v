module d_flip_flop (
    input wire D,
    input wire CLK,
    input wire RST,
    output reg Q
);
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            Q <= 1'b0; // Reset Q to 0
        end else begin
            Q <= D; // Capture D value on clock edge
        end
    end
endmodule