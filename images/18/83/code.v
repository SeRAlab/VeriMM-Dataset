module LDO_Regulator (
    input wire [1:0] control, // Control signal to select output voltage
    output reg [3:0] Vout     // Regulated output voltage (in tens of mV)
);

always @(*) begin
    case (control)
        2'b00: Vout = 4'b1100; // 3.3V
        2'b01: Vout = 4'b0110; // 1.8V
        default: Vout = 4'b0000; // Default to 0V if control signal is invalid
    endcase
end

endmodule