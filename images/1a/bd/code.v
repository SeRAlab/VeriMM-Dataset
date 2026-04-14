module crystal_oscillator (
    input wire clk,        // Clock input
    input wire enable,     // Enable signal
    input wire [3:0] freq, // Frequency input (4-bit binary)
    output reg out         // Output signal
);
    reg [3:0] counter;

    always @(posedge clk) begin
        if (enable) begin
            counter <= counter + 1;
            if (counter >= freq) begin
                out <= ~out;    // Toggle output
                counter <= 0;   // Reset counter
            end
        end
    end
endmodule