module voltage_regulator (
    input wire enable,
    input wire [7:0] reference_voltage,
    output wire [7:0] output_voltage
);
    assign output_voltage = enable ? reference_voltage : 8'b00000000;
endmodule