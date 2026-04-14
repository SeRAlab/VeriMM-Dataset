module LDO_Controller(
    input wire clk,
    input wire enable,
    input wire [7:0] Vin,    // Input voltage
    input wire [7:0] Vref,   // Reference voltage
    output reg [7:0] Vout    // Output voltage
);

always @(posedge clk) begin
    if (enable) begin
        if (Vin >= Vref) begin
            Vout <= Vref;   // Regulate to reference voltage
        end else begin
            Vout <= Vin;    // Pass-through if Vin < Vref
        end
    end else begin
        Vout <= 8'b0;        // Disable output
    end
end

endmodule