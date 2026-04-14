module adc_controller (
    input wire clk,
    input wire reset,
    input wire [23:0] digital_input,
    output reg [15:0] analog_output
);
    parameter V_REF = 16'd32768; // V_ref for 5V is represented as 32768 in 16-bit scaled value

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            analog_output <= 16'b0;
        end else begin
            analog_output <= (digital_input * V_REF) >> 24; // Scale down to 16 bits
        end
    end
endmodule