module adc_comparator(
    input [23:0] adc_value1,
    input [23:0] adc_value2,
    output reg greater_than,
    output reg [1:0] status
);
    always @(*) begin
        if (adc_value1 > adc_value2) begin
            greater_than = 1'b1;
            status = 2'b01; // first is greater
        end else if (adc_value1 < adc_value2) begin
            greater_than = 1'b0;
            status = 2'b10; // second is greater
        end else begin
            greater_than = 1'b0;
            status = 2'b00; // equal
        end
    end
endmodule