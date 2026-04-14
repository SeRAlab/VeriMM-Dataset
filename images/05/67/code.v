module linear_voltage_regulator (
    input wire [4:0] desired_voltage,
    input wire enable,
    output reg [4:0] output_voltage
);

    always @(posedge enable) begin
        output_voltage <= desired_voltage;
    end

    always @(negedge enable) begin
        output_voltage <= 5'b00000; // Reset output to 0 when not enabled
    end

endmodule