module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (S && !R) 
            Q <= 1'b1; // Set
        else if (!S && R) 
            Q <= 1'b0; // Reset
        else if (S && R) 
            Q <= 1'bx; // Invalid state
        // else hold previous state
    end
endmodule