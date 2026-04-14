module LDO (
    input wire [1:0] control,
    input wire [3:0] vin, // 4-bit value representing the input voltage in some scale
    output reg [3:0] vout // 4-bit value for the output voltage in the same scale
);
    always @(*) begin
        if (vin < 4'b0011) // 3.6V threshold (scaled)
            vout = 4'b0000; // 0V
        else begin
            case (control)
                2'b00: vout = 4'b0100; // 1.2V
                2'b01: vout = 4'b1000; // 1.5V
                2'b10: vout = 4'b1100; // 1.8V
                2'b11: vout = 4'b1111; // 3.3V
                default: vout = 4'b0000; // default case
            endcase
        end
    end
endmodule