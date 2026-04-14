module ADC_Controller (
    input wire [7:0] analog_in,
    input wire enable,
    input wire clk,
    output reg [23:0] digital_out
);
    always @(posedge clk) begin
        if (enable) begin
            digital_out <= {16'b0, analog_in}; // Extend to 24 bits
        end
    end
endmodule