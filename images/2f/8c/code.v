module LDO_Regulator (
    input wire clk,
    input wire reset,
    input wire [7:0] ref_voltage,
    input wire control_signal,
    output reg [7:0] output_voltage
);

    reg [7:0] gain = 8'd2; // Fixed gain of 2 for this example
    reg [7:0] temp_output;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            output_voltage <= 8'd0;
        end else if (control_signal) begin
            temp_output <= ref_voltage * gain; // Simple proportional control
            output_voltage <= temp_output;
        end
    end
endmodule