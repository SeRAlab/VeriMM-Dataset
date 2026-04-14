module DAC (
    input [3:0] bin_in,
    output reg [15:0] dac_out
);
    always @(*) begin
        dac_out = 16'b0; // Initialize output to zero
        dac_out[bin_in] = 1'b1; // Set the corresponding bit high
    end
endmodule