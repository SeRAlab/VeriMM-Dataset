module sr_flip_flop (
    input wire S,
    input wire R,
    input wire clk,
    input wire reset,
    input wire set,
    output reg Q
);
    
    always @(posedge clk or posedge reset or posedge set) begin
        if (reset) begin
            Q <= 1'b0;
        end else if (set) begin
            Q <= 1'b1;
        end else if (S && ~R) begin
            Q <= 1'b1; // Set condition
        end else if (~S && R) begin
            Q <= 1'b0; // Reset condition
        end
    end
endmodule