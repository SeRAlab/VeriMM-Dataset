module adc_controller (
    input wire clk,
    input wire reset,
    input wire [23:0] analog_input,
    output reg [23:0] digital_output
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        digital_output <= 24'b0;
    end else begin
        digital_output <= analog_input << 2; // Shift left by 2 bits
    end
end

endmodule