module D_latch (
    input wire D,
    input wire EN,
    input wire R, // Asynchronous reset
    output reg Q
);
    always @ (D or EN or R) begin
        if (R) begin
            Q <= 1'b0; // Reset output to 0
        end else if (EN) begin
            Q <= D; // Latch data when enabled
        end
        // If EN is low, Q retains its previous value
    end
endmodule