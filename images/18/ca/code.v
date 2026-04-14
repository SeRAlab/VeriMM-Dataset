module RC_Oscillator (
    input clk,          // Clock input
    output reg out     // Output square wave
);
    reg [31:0] counter; // Counter for timing
    parameter [31:0] RC_TIME = 32'd10000000; // Define RC time constant

    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter >= RC_TIME) begin
            out <= ~out; // Toggle output
            counter <= 0; // Reset counter
        end
    end
endmodule