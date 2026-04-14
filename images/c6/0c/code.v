module twos_complement(
    input [3:0] binary_input,
    output reg [3:0] twos_complement_output
);

always @(*) begin
    twos_complement_output = ~binary_input + 1;
end

endmodule