module DAC (
    input [15:0] data_in,
    output reg [31:0] analog_out
);
    always @(*) begin
        analog_out = {16'b0, data_in}; // Extend the input with 16 zeros to represent the fractional part
    end
endmodule