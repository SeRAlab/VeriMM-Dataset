module adc_processor (
    input [15:0] adc_value,
    output reg [3:0] range
);
    always @(*) begin
        if (adc_value < 1024)
            range = 4'b0000; // 0
        else if (adc_value < 2048)
            range = 4'b0001; // 1
        else if (adc_value < 3072)
            range = 4'b0010; // 2
        else if (adc_value < 4096)
            range = 4'b0011; // 3
        else
            range = 4'b1111; // Error
    end
endmodule