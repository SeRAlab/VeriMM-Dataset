module vco (
    input clk,
    input [3:0] control,
    output reg vco_out
);
    reg [23:0] counter; // 24-bit counter for frequency division
    reg [23:0] freq_divider;

    always @(*) begin
        freq_divider = (1 << (control + 5)); // Base frequency is 1MHz, shift for VCO frequency
    end

    always @(posedge clk) begin
        if (counter >= freq_divider) begin
            vco_out <= ~vco_out; // Toggle the output
            counter <= 0; // Reset the counter
        end else begin
            counter <= counter + 1; // Increment the counter
        end
    end
endmodule