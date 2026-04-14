module LDO (
    input wire [7:0] Vref,
    input wire [7:0] Vin,
    input wire EN,
    output reg [7:0] Vout
);
    always @(*) begin
        if (EN) begin
            if (Vin > Vref)
                Vout = Vref;
            else
                Vout = 8'b0;
        end else begin
            Vout = 8'b0;
        end
    end
endmodule