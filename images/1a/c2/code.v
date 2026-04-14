module sr_flip_flop (
    input wire clk,
    input wire S,
    input wire R,
    output reg Q
);
    always @(posedge clk) begin
        if (S && !R) begin
            Q <= 1'b1; // Set
        end else if (!S && R) begin
            Q <= 1'b0; // Reset
        end 
        // If both S and R are low, Q remains unchanged
    end
endmodule