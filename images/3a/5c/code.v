module switching_regulator (
    input wire clk,
    input wire enable,
    input wire [7:0] duty_cycle, // Duty cycle as a percentage (0-100)
    input wire [7:0] vin,         // Input voltage
    output reg [7:0] vout        // Output voltage
);

    reg [7:0] counter;

    always @(posedge clk) begin
        if (enable) begin
            if (counter < duty_cycle) begin
                vout <= vin; // Output voltage is equal to input during high phase
            end else begin
                vout <= 0;   // Output voltage is grounded during low phase
            end
            counter <= (counter + 1) % 100; // Cycle counter from 0 to 99
        end else begin
            vout <= 0; // Disable output voltage when not enabled
            counter <= 0; // Reset counter
        end
    end
endmodule