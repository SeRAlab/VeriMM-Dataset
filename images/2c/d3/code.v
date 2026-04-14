module adc_comparator(
    input [15:0] data_in1,
    input [15:0] data_in2,
    output reg [1:0] result
);

always @(*) begin
    if (data_in1 > data_in2)
        result = 2'b01; // data_in1 > data_in2
    else if (data_in1 < data_in2)
        result = 2'b10; // data_in1 < data_in2
    else
        result = 2'b00; // data_in1 == data_in2
end

endmodule