module jk_flip_flop (
    input wire J,
    input wire K,
    input wire CLK,
    output reg Q
);
    always @(posedge CLK) begin
        if (J == 1'b0 && K == 1'b0) 
            Q <= Q; // No change
        else if (J == 1'b1 && K == 1'b0) 
            Q <= 1'b1; // Set
        else if (J == 1'b0 && K == 1'b1) 
            Q <= 1'b0; // Reset
        else if (J == 1'b1 && K == 1'b1) 
            Q <= ~Q; // Toggle
    end
endmodule