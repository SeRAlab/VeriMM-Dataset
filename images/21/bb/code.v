module crystal_oscillator (
    input clk,                // Input clock
    input [3:0] freq_control, // Frequency control input (4-bit)
    output reg out           // Output square wave
);
    reg [3:0] counter;        // Counter for the clock division
    reg [3:0] div_value;      // Value to divide the input clock

    always @(posedge clk) begin
        // Calculate the division value based on freq_control
        div_value <= freq_control;

        // Increment the counter
        counter <= counter + 1;

        // Toggle output when counter reaches half of div_value
        if (counter >= div_value) begin
            out <= ~out; // Toggle output
            counter <= 0; // Reset the counter
        end
    end
endmodule