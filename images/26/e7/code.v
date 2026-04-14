module vco (
    input wire clk,
    input wire reset,
    input wire [1:0] control_voltage, // Control voltage to determine frequency
    output reg vco_out
);

reg [23:0] counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 24'd0;
        vco_out <= 1'b0;
    end else begin
        counter <= counter + 1;
        // Adjust output frequency based on control voltage
        if (counter > (1 << (control_voltage + 8))) begin
            vco_out <= ~vco_out;
            counter <= 24'd0; // Reset counter after toggling
        end
    end
end

endmodule