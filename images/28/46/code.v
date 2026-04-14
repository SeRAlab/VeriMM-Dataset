module d_latch (
    input wire D,
    input wire C,
    output reg Q
);
    always @(D or C) begin
        if (C) begin
            Q <= D;  // When C is high, Q follows D
        end
        // When C is low, Q retains its value
    end
endmodule