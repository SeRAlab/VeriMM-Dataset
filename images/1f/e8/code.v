module LDO_Regulator (
    input wire enable,
    output reg output_voltage
);
    always @(*) begin
        if (enable) begin
            output_voltage = 1'b1; // 5V represented as logic high
        end else begin
            output_voltage = 1'b0; // 0V represented as logic low
        end
    end
endmodule