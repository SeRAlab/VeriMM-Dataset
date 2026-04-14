module DFlipFlop (
    input wire D,
    input wire CLK,
    input wire RSTn,
    output reg Q
);
    always @(posedge CLK or negedge RSTn) begin
        if (!RSTn) begin
            Q <= 0;
        end else begin
            Q <= D;
        end
    end
endmodule