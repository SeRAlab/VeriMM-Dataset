module sum_4bit(input [3:0] input_a, output reg [4:0] output_sum);

always @(*) begin
    output_sum = {1'b0, input_a} + 4'b0001;
end

endmodule