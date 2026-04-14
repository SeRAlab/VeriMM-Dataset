module dct_4point (
    input [3:0] input_vector,
    output reg [3:0] output_vector
);

always @(*) begin
    output_vector[0] = (input_vector[0] + input_vector[1] + input_vector[2] + input_vector[3]) >> 1;
    output_vector[1] = (input_vector[0] + input_vector[1] - input_vector[2] - input_vector[3]) >> 1;
    output_vector[2] = (input_vector[0] - input_vector[1] + input_vector[2] - input_vector[3]) >> 1;
    output_vector[3] = (input_vector[0] - input_vector[1] - input_vector[2] + input_vector[3]) >> 1;
end

endmodule