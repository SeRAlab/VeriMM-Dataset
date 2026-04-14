module gpio_controller (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] latch;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            latch <= 4'b0000;
            data_out <= 4'b0000;
        end else if (enable) begin
            // Read operation
            data_out <= data_in;
        end else begin
            // Write operation
            latch <= data_out;
        end
    end
endmodule