module voltage_regulator (
    input [4:0] Vin,
    input EN,
    output reg [4:0] Vout
);
    parameter THRESHOLD = 5; // 5V threshold

    always @(*) begin
        if (EN == 1'b0) begin
            Vout = 5'b00000; // Vout = 0V
        end else if (Vin < THRESHOLD) begin
            Vout = Vin; // Vout = Vin
        end else begin
            Vout = THRESHOLD; // Vout = 5V
        end
    end
endmodule