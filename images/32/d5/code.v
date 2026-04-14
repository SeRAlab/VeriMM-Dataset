module adc_controller (
    input wire clk,
    input wire reset,
    input wire [15:0] din,
    output reg [7:0] dout,
    output reg ready
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dout <= 8'b0;
            ready <= 0;
        end else begin
            dout <= din[15:8];  // Take the upper 8 bits as output
            ready <= 1;         // Indicate that the conversion is complete
        end
    end
endmodule