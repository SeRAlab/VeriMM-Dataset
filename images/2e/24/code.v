module VCO (
    input wire clk,
    input wire [7:0] ctrl_voltage,
    output reg osc_out
);
    reg [15:0] counter;
    reg [15:0] threshold;

    always @(posedge clk) begin
        // Calculate the threshold based on control voltage
        threshold <= (ctrl_voltage * 10000) / 255; // Scale to 10 KHz
        
        // Increment the counter
        counter <= counter + 1;

        // Toggle the output based on the threshold
        if (counter >= threshold) begin
            osc_out <= ~osc_out; // Toggle output
            counter <= 0; // Reset counter
        end
    end
endmodule