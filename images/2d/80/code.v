module D_latch (
    input wire D,
    input wire E,
    output reg Q
);
    always @(D or E) begin
        if (E) begin
            Q <= D; // Capture input when enabled
        end
        // Q holds its value when E is low
    end
endmodule