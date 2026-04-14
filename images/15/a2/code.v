module DAC_24bit (
    input [23:0] data_in,
    input valid,
    output reg analog_out
);

always @(*) begin
    if (valid) begin
        // Simple representation of analog output as a binary value (for simulation purposes)
        analog_out = data_in; 
    end else begin
        analog_out = 0; // No valid input
    end
end

endmodule