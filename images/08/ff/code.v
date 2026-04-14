module fractional_n_pll (
    input wire clk_ref, // Reference clock input
    input wire [7:0] frac_val, // Fractional value
    output reg clk_out // Output clock
);
    reg [15:0] count;
    reg [7:0] freq_mul;

    always @(posedge clk_ref) begin
        count <= count + 1;
        if (count >= freq_mul) begin
            clk_out <= ~clk_out; // Toggle output clock
            count <= 0;
        end
    end

    always @(frac_val) begin
        freq_mul <= (frac_val * 10); // Adjust frequency multiplier based on frac_val
    end
endmodule