module adc_controller(
    input wire clk,
    input wire rst,
    input wire [15:0] adc_in,
    output reg [15:0] adc_out
);

    parameter THRESHOLD = 16'h8000; // 32768 in decimal
    parameter MAX_VALUE = 16'hFFFF; // 65535 in decimal

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            adc_out <= 16'b0;
        end else begin
            if (adc_in >= THRESHOLD) begin
                adc_out <= MAX_VALUE;
            end else begin
                adc_out <= adc_in;
            end
        end
    end
endmodule