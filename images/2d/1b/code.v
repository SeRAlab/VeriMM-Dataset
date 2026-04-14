module crystal_oscillator (
    input wire clk,
    input wire enable,
    output reg out
);
    initial begin
        out = 0; // Initial state
    end
    
    always @(posedge clk) begin
        if (enable) begin
            out <= ~out; // Toggle output
        end
    end
endmodule