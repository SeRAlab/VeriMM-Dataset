module D_latch (
    input wire D,
    input wire E,
    output reg Q
);
    always @ (D or E) begin
        if (E) begin
            Q <= D; // When E is high, Q follows D
        end
        // When E is low, Q retains its value
    end
endmodule