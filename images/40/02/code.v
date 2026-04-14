module LDO_Regulator (
    input [7:0] Vin,
    input [7:0] Vref,
    output reg [7:0] Vout
);
    parameter Vdrop = 8'd30; // 0.3V in 8-bit representation (e.g., assuming Vref = 1V = 100)

    always @(*) begin
        if (Vin < Vref + Vdrop) begin
            Vout = Vin; // Vout set to Vin if input is lower than Vref + Vdrop
        end else begin
            Vout = Vref; // Otherwise, set Vout to Vref
        end
    end
endmodule