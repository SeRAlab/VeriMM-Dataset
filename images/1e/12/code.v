module LDO_Regulator (
    input [7:0] Vin,
    input Enable,
    output reg [7:0] Vout
);
    parameter THRESHOLD = 8'd200; // Define the maximum output voltage threshold

    always @(*) begin
        if (Enable) begin
            if (Vin > THRESHOLD) begin
                Vout = THRESHOLD; // Clamp to threshold
            end else begin
                Vout = Vin; // Output equals input voltage
            end
        end else begin
            Vout = 8'd0; // Output is zero when not enabled
        end
    end
endmodule