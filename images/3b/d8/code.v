module adc_8bit (
    input [7:0] Vin,
    input enable,
    output reg [7:0] Vout
);
    always @(*) begin
        if (enable) begin
            Vout = Vin; // Convert input to output
        end
    end
endmodule