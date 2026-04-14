module vco (
    input wire clk,
    input wire enable,
    input wire [2:0] control_voltage,
    output reg clk_out
);
    reg [23:0] counter;
    reg [23:0] frequency_divider;

    always @(posedge clk) begin
        if (enable) begin
            frequency_divider <= 24'd1000000 / (control_voltage + 1); // Frequency calculation
            counter <= counter + 1;
            if (counter >= frequency_divider) begin
                clk_out <= ~clk_out; // Toggle output
                counter <= 24'd0; // Reset counter
            end
        end else begin
            clk_out <= 0; // Disable output
            counter <= 24'd0; // Reset counter
        end
    end
endmodule