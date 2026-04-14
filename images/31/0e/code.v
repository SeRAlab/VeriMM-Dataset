module LDO_Controller (
    input wire clk,
    input wire reset,
    input wire [7:0] Vin, // Input voltage
    input wire [7:0] Vref, // Reference voltage
    output reg Vout // Output voltage
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Vout <= 0;
        end else begin
            if (Vin >= Vref) begin
                Vout <= Vref; // Regulate to reference voltage
            end else begin
                Vout <= Vin; // Pass through input voltage if less than reference
            end
        end
    end
endmodule