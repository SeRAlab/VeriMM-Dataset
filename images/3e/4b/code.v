module LDO_Controller(
    input wire clk,
    input wire reset,
    input wire [7:0] ref_voltage,
    input wire [7:0] feedback_voltage,
    output reg gate_signal
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            gate_signal <= 0;
        end else begin
            if (feedback_voltage < ref_voltage) begin
                gate_signal <= 1; // Increase gate signal
            end else if (feedback_voltage > ref_voltage) begin
                gate_signal <= 0; // Decrease gate signal
            end
        end
    end
endmodule