module sr_latch (
    input S,     // Set input
    input R,     // Reset input
    output reg Q,  // Output Q
    output reg Q_n // Output not Q
);
    
    always @ (S, R) begin
        if (S && !R) begin
            Q <= 1'b1;    // Set Q to 1
        end else if (!S && R) begin
            Q <= 1'b0;    // Reset Q to 0
        end // Maintain state if both S and R are low
        Q_n <= ~Q; // Invert Q for Q_n
    end
    
endmodule