module jk_latch (
    input J,
    input K,
    input CLK,
    output reg Q
);
    always @(posedge CLK) begin
        if (J == 0 && K == 0) Q <= Q; // Maintain previous state
        else if (J == 1 && K == 0) Q <= 1; // Set Q
        else if (J == 0 && K == 1) Q <= 0; // Reset Q
        else if (J == 1 && K == 1) Q <= ~Q; // Toggle Q
    end
endmodule