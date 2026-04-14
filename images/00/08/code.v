module gpio_controller(
    input wire clk,
    input wire rst,
    input wire ctrl,
    input wire [7:0] data_in,
    input wire [7:0] data_out,
    output reg [7:0] gpio
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            gpio <= 8'b00000000; // Initialize to low
        end else if (ctrl) begin
            gpio <= data_out; // Set GPIO as output
        end else begin
            gpio <= data_in; // Set GPIO as input
        end
    end

endmodule