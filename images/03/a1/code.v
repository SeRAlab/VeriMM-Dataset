module gpio_controller(
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    input wire [2:0] pin_num,
    input wire write_enable,
    output reg [3:0] data_out
);
    reg [3:0] pins [0:7]; // 8 pins, each 4-bits wide

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all pins
            pins[0] <= 4'b0000;
            pins[1] <= 4'b0000;
            pins[2] <= 4'b0000;
            pins[3] <= 4'b0000;
            pins[4] <= 4'b0000;
            pins[5] <= 4'b0000;
            pins[6] <= 4'b0000;
            pins[7] <= 4'b0000;
            data_out <= 4'b0000;
        end else begin
            if (write_enable) begin
                // Write data to the specified pin
                pins[pin_num] <= data_in;
            end else begin
                // Read data from the specified pin
                data_out <= pins[pin_num];
            end
        end
    end
endmodule