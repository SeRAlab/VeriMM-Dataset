module adc_controller (
    input wire clk,
    input wire [15:0] adc_input,
    input wire [15:0] reference,
    output reg [15:0] digital_output
);

always @(posedge clk) begin
    if (adc_input > reference)
        digital_output <= 16'hFFFF;
    else
        digital_output <= 16'h0000;
end

endmodule