module LDO_Regulator (
    input wire [3:0] Vin,    // 4-bit input voltage (0 to 15)
    input wire feedback,      // feedback control signal
    output reg [3:0] Vout     // 4-bit output voltage
);
    always @(*) begin
        if (feedback) 
            Vout = Vin; // Output equals input when feedback is high
        else 
            Vout = Vin - 4'b0001; // Output is input minus 1V when feedback is low
    end
endmodule