module LDO_Regulator (
    input wire [7:0] V_in,  // Input voltage (8-bit)
    input wire enable,       // Enable signal
    output reg [7:0] V_out   // Output voltage (8-bit)
);

    parameter THRESHOLD = 8'd100; // Threshold voltage
    parameter REGULATED_VOLTAGE = 8'd90; // Regulated output voltage

    always @(*) begin
        if (enable) begin
            if (V_in >= THRESHOLD) begin
                V_out = REGULATED_VOLTAGE; // Output regulated voltage
            end else begin
                V_out = V_in; // Output follows input if below threshold
            end
        end else begin
            V_out = 8'd0; // If not enabled, output is zero
        end
    end

endmodule