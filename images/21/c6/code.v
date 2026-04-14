module gated_flip_flop (
    input wire D,
    input wire CLK,
    input wire RST,
    input wire CG,
    output reg Q
);

always @(posedge CLK or posedge RST) begin
    if (RST) begin
        Q <= 0;
    end else if (CG) begin
        Q <= D;
    end
    // If CG is low, Q holds its value
end

endmodule