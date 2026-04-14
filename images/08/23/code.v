module D_latch (
    input wire D,      // Data input
    input wire EN,     // Enable signal
    output reg Q       // Output
);
    always @* begin
        if (EN) begin
            Q = D;     // Capture data when EN is high
        end
        // If EN is low, Q retains its previous value
    end
endmodule