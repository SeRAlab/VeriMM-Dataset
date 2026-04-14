module D_latch (
    input wire D,
    input wire E,
    input wire R,
    output reg Q
);
    always @ (D or E or R) begin
        if (R) begin
            Q <= 0;  // Reset Q to 0
        end else if (E) begin
            Q <= D;  // Capture D when E is high
        end
    end
endmodule