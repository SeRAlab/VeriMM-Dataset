module d_latch (
    input wire D,
    input wire E,
    output reg Q
);
    always @(D or E) begin
        if (E) begin
            Q <= D;
        end
        // When E is low, Q retains its previous value
    end
endmodule