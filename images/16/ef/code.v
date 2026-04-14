module adc_controller (
    input wire clk,
    input wire reset,
    input wire [23:0] adc_input,
    output reg [23:0] adc_output
);
    reg [23:0] internal_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            internal_reg <= 24'b0;
        end else begin
            internal_reg <= adc_input;
        end
    end

    always @(internal_reg) begin
        adc_output <= internal_reg;
    end
endmodule