module fractional_n_pll (
    input wire clk_ref,          // Reference clock
    input wire reset,           // Reset signal
    input wire [7:0] N,         // Integer division factor
    input wire [7:0] F,         // Fractional division factor
    output reg clk_out          // Output clock
);
    reg [31:0] counter;
    reg [31:0] fractional_counter;

    always @(posedge clk_ref or posedge reset) begin
        if (reset) begin
            counter <= 0;
            fractional_counter <= 0;
            clk_out <= 0;
        end else begin
            fractional_counter <= fractional_counter + F;
            if (fractional_counter >= 256) begin
                clk_out <= ~clk_out; // Toggle output clock
                fractional_counter <= fractional_counter - 256;
            end

            counter <= counter + 1;
            if (counter >= N) begin
                counter <= 0;
                clk_out <= ~clk_out; // Toggle output clock for N
            end
        end
    end
endmodule