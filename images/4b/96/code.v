module top_module(
    input [15:0] input_value,
    output reg [3:0] output_value
);integer i;

always @(*) begin
    output_value = 0;
    for (i = 0; i < 16; i = i + 1) begin
        if (input_value[i] == 1) begin
            output_value = output_value + 1;
        end
    end
end

endmodule