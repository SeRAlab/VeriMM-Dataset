module ADC_16bit (
    input wire [7:0] voltage_in,
    input wire enable,
    output reg [15:0] voltage_out
);
    always @(*) begin
        if (enable) begin
            voltage_out = {8'b0, voltage_in}; // Expand to 16-bits
        end else begin
            voltage_out = 16'b0; // Output zero when not enabled
        end
    end
endmodule