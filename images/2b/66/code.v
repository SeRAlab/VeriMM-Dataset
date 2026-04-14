module switching_regulator (
    input [7:0] input_voltage,
    input enable,
    output reg [7:0] output_voltage
);
    parameter REF_VOLTAGE = 8'd250;  // Reference voltage 2.5V represented as 250
    always @(*) begin
        if (enable) begin
            if (input_voltage > REF_VOLTAGE) begin
                output_voltage = input_voltage - (input_voltage - REF_VOLTAGE);
            end else begin
                output_voltage = input_voltage + (REF_VOLTAGE - input_voltage);
            end
        end else begin
            output_voltage = 8'd0;  // If not enabled, output zero
        end
    end
endmodule