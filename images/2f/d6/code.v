module DAC_Controller (
    input [3:0] ctrl,
    output reg [15:0] dac_out
);
    
    always @(*) begin
        case (ctrl)
            4'b0000: dac_out = 16'h0000; // 0V
            4'b0001: dac_out = 16'h1FFF; // 0.5V
            4'b0010: dac_out = 16'h3FFF; // 1.0V
            4'b0011: dac_out = 16'h5FFF; // 1.5V
            4'b0100: dac_out = 16'h7FFF; // 2.0V
            4'b0101: dac_out = 16'h9FFF; // 2.5V
            4'b0110: dac_out = 16'hBFFF; // 3.0V
            4'b0111: dac_out = 16'hDFFF; // 3.5V
            4'b1000: dac_out = 16'hFFFF; // 4.0V
            4'b1001: dac_out = 16'hEFFF; // 4.5V
            4'b1010: dac_out = 16'hDFFF; // 5.0V
            4'b1011: dac_out = 16'hCFFF; // 5.5V
            4'b1100: dac_out = 16'hBFFF; // 6.0V
            4'b1101: dac_out = 16'hAFFF; // 6.5V
            4'b1110: dac_out = 16'h9FFF; // 7.0V
            4'b1111: dac_out = 16'h8FFF; // 7.5V
            default: dac_out = 16'h0000; // Default to 0V
        endcase
    end
endmodule