module gpio_controller(
    input wire clk,
    input wire reset,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 4'b0000; // Reset output to 0
        end else begin
            data_out <= data_in; // Update output with input data
        end
    end
endmodule