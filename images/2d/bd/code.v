module adc_controller (
    input wire clk,
    input wire reset,
    input wire [7:0] analog_in,
    output reg [15:0] digital_out
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            digital_out <= 16'b0;
        end else begin
            digital_out <= {8'b0, analog_in}; // Extend 8-bit to 16-bit
        end
    end
endmodule