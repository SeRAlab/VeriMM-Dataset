module adc_controller(
    input wire clk,
    input wire reset,
    input wire [15:0] adc_input,
    output reg [11:0] adc_output,
    output reg valid
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            adc_output <= 12'b0;
            valid <= 1'b0;
        end else begin
            adc_output <= adc_input >> 4; // Scale down by a factor of 16
            valid <= 1'b1; // Output valid after conversion
        end
    end
endmodule