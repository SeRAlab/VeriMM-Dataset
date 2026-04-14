module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    output reg Q
);
    always @(posedge clk) begin
        if (S && !R) 
            Q <= 1; // Set
        else if (!S && R) 
            Q <= 0; // Reset
        // If S and R are both 0, Q remains unchanged
    end
endmodule