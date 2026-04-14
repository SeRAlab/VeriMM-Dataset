module LDO (
    input wire [4:0] Vin,    // 5-bit input voltage
    input wire enable,       // Enable signal
    output reg [4:0] Vout    // 5-bit output voltage
);

always @(*) begin
    if (enable) begin
        Vout = Vin;          // Output is equal to input when enabled
    end else begin
        Vout = 5'b00000;     // Output is zero when disabled
    end
end

endmodule