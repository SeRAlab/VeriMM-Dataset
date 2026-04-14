module clock_gating (
    input wire clk,        // Input clock signal
    input wire enable,     // Control signal for clock gating
    output reg gated_clk   // Output gated clock signal
);
    
    always @(posedge clk) begin
        if (enable) begin
            gated_clk <= 1'b1;
        end else begin
            gated_clk <= 1'b0;
        end
    end
endmodule