module adc_16bit (
    input [15:0] adc_input,
    output reg [3:0] adc_output
);
    always @(*) begin
        if (adc_input <= 16'd16384) begin
            adc_output = 4'd0;
        end else if (adc_input <= 16'd32768) begin
            adc_output = 4'd1;
        end else if (adc_input <= 16'd49152) begin
            adc_output = 4'd2;
        end else begin
            adc_output = 4'd3;
        end
    end
endmodule