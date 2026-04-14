module linear_voltage_regulator (
    input [7:0] Vin,
    input [1:0] Gain,
    input EN,
    output reg [7:0] Vout
);
    always @(*) begin
        if (EN) begin
            case (Gain)
                2'b00: Vout = Vin;        // Gain = 1
                2'b01: Vout = Vin << 1;   // Gain = 2
                2'b10: Vout = Vin * 3;     // Gain = 3
                default: Vout = 0;
            endcase
        end else begin
            Vout = 0;
        end
    end
endmodule