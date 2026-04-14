module DAC (
    input [15:0] binary_input,
    input latch,        // Latch signal to hold the output
    output reg [15:0] analog_output
);

always @(*) begin
    if (latch) begin
        analog_output <= binary_input; // Latch the current input
    end
end

endmodule