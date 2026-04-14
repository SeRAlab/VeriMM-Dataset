module LDO_Regulator (
    input wire [7:0] Vin,
    input wire [7:0] Vtarget,
    input wire [7:0] Vmax,
    input wire enable,
    output reg [7:0] Vout
);
    always @(*) begin
        if (enable) begin
            if (Vin >= Vtarget && Vtarget <= Vmax) begin
                Vout = Vtarget;
            end else if (Vin < Vtarget) begin
                Vout = Vin; // Output cannot exceed input
            end else begin
                Vout = Vmax; // Limit output to maximum
            end
        end else begin
            Vout = 8'b0; // Output is 0 when disabled
        end
    end
endmodule