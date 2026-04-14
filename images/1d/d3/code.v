module voltage_regulator (
    input wire clk,
    input wire [4:0] input_voltage,
    output reg [4:0] output_voltage
);
    parameter SCALING_FACTOR = 3;
    always @(posedge clk) begin
        output_voltage <= (input_voltage * SCALING_FACTOR > 31) ? 5'b11111 : input_voltage * SCALING_FACTOR;
    end
endmodule