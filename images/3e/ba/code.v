module D_latch (
    input wire D,
    input wire E,
    output reg Q
);
    always @ (D or E) begin
        if (E) begin
            Q <= D;  // Capture input D if enable E is high
        end
        // If E is low, Q retains its previous state
    end
endmodule