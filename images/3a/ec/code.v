module sr_flip_flop (
    input wire S,
    input wire R,
    input wire CLK,
    output reg Q
);
    always @(posedge CLK) begin
        if (S && ~R) begin
            Q <= 1; // Set Q to 1
        end else if (~S && R) begin
            Q <= 0; // Reset Q to 0
        end else if (~S && ~R) begin
            // Maintain previous state
            Q <= Q; 
        end
        // If S and R are both 1, do nothing (invalid state)
    end
endmodule