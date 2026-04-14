module linear_voltage_regulator (
    input wire clk,
    input wire reset,
    input wire [4:0] ref_voltage,
    output reg [4:0] regulated_voltage
);
    parameter TOLERANCE = 2;
    parameter DEFAULT_VOLTAGE = 5'b00000;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            regulated_voltage <= DEFAULT_VOLTAGE;
        end else begin
            if (ref_voltage >= (regulated_voltage - TOLERANCE) && ref_voltage <= (regulated_voltage + TOLERANCE)) begin
                regulated_voltage <= ref_voltage; // Follow the reference voltage within tolerance
            end
        end
    end
endmodule