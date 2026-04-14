module d_flip_flop (
    input wire D,
    input wire clk,
    output reg Q
);
    wire S, R;
    
    assign S = D & clk;  // Set condition
    assign R = ~D & clk; // Reset condition

    always @(posedge clk) begin
        if (S) 
            Q <= 1'b1;  // Set Q to 1
        else if (R) 
            Q <= 1'b0;  // Reset Q to 0
    end
endmodule