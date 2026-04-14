module top_module(
    input CLK,
    input D,
    input RESET_B,
    output reg Q
);always @(posedge CLK or negedge RESET_B) begin
        if (!RESET_B)
            Q <= 1'b0; // Reset state
        else
            Q <= D;     // Capture data
    end

endmodule