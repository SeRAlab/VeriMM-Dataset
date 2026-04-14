module adc_threshold (
    input [15:0] adc_value,
    output reg threshold_exceeded
);
    parameter THRESHOLD = 16'h8000;

    always @(*) begin
        if (adc_value >= THRESHOLD) 
            threshold_exceeded = 1;
        else 
            threshold_exceeded = 0;
    end
endmodule