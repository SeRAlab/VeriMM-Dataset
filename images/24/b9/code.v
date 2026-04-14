module adc_encoder (
    input [15:0] adc_in,
    output reg [3:0] encoded_out
);
    always @(*) begin
        if (adc_in < 1024)
            encoded_out = 4'b0000; // 0
        else if (adc_in < 2048)
            encoded_out = 4'b0001; // 1
        else if (adc_in < 3072)
            encoded_out = 4'b0010; // 2
        else if (adc_in < 4096)
            encoded_out = 4'b0011; // 3
        else
            encoded_out = 4'b0011; // clamped to 3
    end
endmodule