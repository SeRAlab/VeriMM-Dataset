module DAC_24bit (
    input [23:0] binary_input,
    output reg [31:0] analog_output
);
    always @(*) begin
        analog_output = binary_input * (32'hFFFFFFFF / 24'hFFFFFF);
    end
endmodule