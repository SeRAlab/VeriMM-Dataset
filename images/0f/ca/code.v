module linear_voltage_regulator (
    input wire [7:0] ref_voltage,   // 8-bit reference voltage input
    input wire [7:0] input_voltage,  // 8-bit input voltage
    output reg [7:0] output_voltage   // 8-bit regulated output voltage
);

    always @(*) begin
        if (input_voltage >= ref_voltage) begin
            output_voltage = ref_voltage; // Output matches reference if input is sufficient
        end else begin
            output_voltage = 8'b00000000; // Output is zero if input is insufficient
        end
    end
endmodule