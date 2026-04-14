module rc_oscillator (
    input wire clk,          // Clock signal
    input wire reset,        // Reset signal
    input wire [3:0] freq,   // Frequency control input
    output reg square_wave   // Output square wave signal
);
    reg [23:0] counter;      // 24-bit counter for timing

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            square_wave <= 0;
        end else begin
            if (counter < freq * 1000) begin
                counter <= counter + 1;
            end else begin
                counter <= 0;
                square_wave <= ~square_wave; // Toggle the square wave
            end
        end
    end
endmodule