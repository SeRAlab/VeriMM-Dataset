module DAC_Controller (
    input wire [23:0] data_in,
    input wire enable,
    output reg [7:0] analog_out
);

always @(*) begin
    if (enable) begin
        analog_out = data_in[23:16]; // Take the most significant 8 bits
    end
end

endmodule