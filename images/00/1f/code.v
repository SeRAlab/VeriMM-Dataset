module crystal_oscillator (
    input wire clk,               // Input clock signal
    input wire [3:0] freq_div,   // Frequency divider
    output reg osc_out           // Output square wave
);
    reg [3:0] counter;           // Counter to track clock cycles

    always @(posedge clk) begin
        if (counter == freq_div) begin
            osc_out <= ~osc_out; // Toggle output
            counter <= 0;        // Reset counter
        end else begin
            counter <= counter + 1; // Increment counter
        end
    end
endmodule