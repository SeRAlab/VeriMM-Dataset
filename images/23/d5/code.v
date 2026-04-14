module adc_processor (
    input [23:0] adc_input,
    output reg [3:0] status
);
    always @(*) begin
        if (adc_input <= 15) begin
            status = 4'b0001; // Range 0-15
        end else if (adc_input <= 255) begin
            status = 4'b0010; // Range 16-255
        end else if (adc_input <= 4095) begin
            status = 4'b0100; // Range 256-4095
        end else if (adc_input <= 65535) begin
            status = 4'b1000; // Range 4096-65535
        end else begin
            status = 4'b1111; // Out of range
        end
    end
endmodule