module D_Latch (
    input wire D,
    input wire EN,
    output reg Q
);
    always @(D or EN) begin
        if (EN) begin
            Q <= D; // Update output when enable is high
        end
        // When enable is low, do nothing (hold previous value)
    end
endmodule