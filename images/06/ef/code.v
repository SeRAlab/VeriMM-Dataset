module LDO_Regulator (
    input wire [7:0] Vin,     // Input voltage
    input wire Ctrl,          // Control signal
    output reg [7:0] Vout     // Output voltage
);
    parameter Vref = 8'b01111111; // Reference voltage (127 in decimal)
    parameter Vdropout = 8'b00000100; // Dropout voltage (4 in decimal)

    always @(*) begin
        if (Ctrl) begin
            if (Vin > (Vref + Vdropout))
                Vout = Vref; // When input is higher than reference + dropout, output regulated to Vref
            else
                Vout = Vin; // Otherwise, output is the input
        end else begin
            Vout = 8'b00000000; // When control is low, output is 0
        end
    end
endmodule