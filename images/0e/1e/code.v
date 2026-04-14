module adc_16bit (
    input wire [15:0] data_in, // 16-bit input data
    input wire clk,            // clock signal
    input wire enable,         // enable signal
    output reg [15:0] data_out // 16-bit output data
);

always @(posedge clk) begin
    if (enable) begin
        data_out <= data_in; // Store input data on clock edge if enabled
    end
end

endmodule