module gpio_controller (
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    input wire mode,   // 0 for input, 1 for output
    input wire enable,
    output reg [3:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 4'b0000;
        end else if (enable) begin
            if (mode) begin
                data_out <= data_in; // Output mode
            end else begin
                data_out <= data_out; // Hold the data in input mode
            end
        end
    end
endmodule