module LDO (
    input wire [7:0] Vin,    // Input voltage
    input wire [7:0] Vref,   // Reference voltage
    input wire EN,           // Enable signal
    output reg [7:0] Vout    // Output voltage
);

always @(*) begin
    if (EN) begin
        if (Vin > Vref)
            Vout = Vref;
        else
            Vout = 8'b0; // 0 when Vin < Vref
    end else begin
        Vout = 8'b0; // 0 when EN is low
    end
end

endmodule