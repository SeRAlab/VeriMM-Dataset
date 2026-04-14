module LDO (
    input wire clk,
    input wire enable,
    input wire [3:0] Vin,    // 4-bit input voltage (0V to 15V)
    output reg [3:0] Vout    // 4-bit output voltage (0V to 15V)
);
    parameter Vref = 4'b1100; // Reference voltage (3.3V in 4-bit representation)
    
    always @(posedge clk) begin
        if (enable) begin
            if (Vin >= Vref) 
                Vout <= Vref; // Output tracks reference voltage
            else 
                Vout <= Vin;   // Output follows input voltage
        end else begin
            Vout <= 4'b0000; // Output is 0V when disabled
        end
    end
endmodule