module RC_Oscillator (
    input wire clk,            // Clock input
    input wire reset,          // Asynchronous reset
    input wire [3:0] period,   // Time constant to determine frequency
    output reg out            // Oscillator output
);

reg [3:0] counter;            // Counter to track clock cycles

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;
        out <= 0;            // Reset output
    end else begin
        if (counter < period) begin
            counter <= counter + 1;
        end else begin
            out <= ~out;     // Toggle output
            counter <= 0;    // Reset counter
        end
    end
end

endmodule