module clock_gating (
    input wire clk,
    input wire enable,
    output reg gated_clk
);
    
    always @(posedge clk) begin
        if (enable) 
            gated_clk <= 1'b1; // Gated clock is high when enabled
        else 
            gated_clk <= 1'b0; // Gated clock is low when disabled
    end

endmodule