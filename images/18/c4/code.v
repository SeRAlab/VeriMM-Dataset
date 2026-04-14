module ADC_24to12 (
    input wire clk,
    input wire reset,
    input wire [23:0] analog_input,
    output reg [11:0] digital_output
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            digital_output <= 12'b0;
        end else begin
            digital_output <= analog_input[23:12]; // Take the most significant 12 bits
        end
    end
endmodule