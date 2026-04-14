module DFlipFlop (
    input wire D,
    input wire CLK,
    input wire R,
    output reg Q
);
    always @(posedge CLK or posedge R) begin
        if (R) begin
            Q <= 0; // Asynchronous reset
        end else begin
            Q <= D; // Capture D on rising edge of CLK
        end
    end
endmodule