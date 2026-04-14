module top_module(
    input [15:0] input_16,
    output reg [3:0] num_ones
);always @(*) begin
    num_ones = (input_16[0] + input_16[1] + input_16[2] + input_16[3] +
                input_16[4] + input_16[5] + input_16[6] + input_16[7] +
                input_16[8] + input_16[9] + input_16[10] + input_16[11] +
                input_16[12] + input_16[13] + input_16[14] + input_16[15]);
end

endmodule