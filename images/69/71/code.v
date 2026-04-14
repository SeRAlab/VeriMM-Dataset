module top_module(
    input [3:0] binary_input,
    output reg [3:0] twos_complement_output
);always @(*) begin
        if (binary_input[3] == 1) begin
            twos_complement_output = ~binary_input + 1;
        end else begin
            twos_complement_output = binary_input;
        end
    end

endmodule