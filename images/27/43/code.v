module sr_latch (
    input wire clk,
    input wire S,
    input wire R,
    output reg Q
);
    
    always @(posedge clk) begin
        if (S && !R) 
            Q <= 1'b1; // Set
        else if (!S && R) 
            Q <= 1'b0; // Reset
        // If S=0 and R=0, Q remains unchanged
    end
endmodule