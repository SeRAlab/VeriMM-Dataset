module DAC_24bit (
    input [23:0] data_in,
    input control,
    output reg [23:0] voltage_out
);
    always @(*) begin
        if (control) begin
            voltage_out = data_in; // Valid output
        end else begin
            voltage_out = 24'b0; // Invalid output (0V)
        end
    end
endmodule