module gpio_controller (
    input wire clk,
    input wire rst,
    input wire ctrl, // Control signal: 1 for read, 0 for write
    input wire [3:0] gpio_in, // GPIO input pins
    output reg [3:0] gpio_out // GPIO output pins
);

reg [3:0] data_reg;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_reg <= 4'b0000;
        gpio_out <= 4'b0000;
    end else begin
        if (ctrl) begin
            data_reg <= gpio_in; // Read from GPIO input
        end else begin
            gpio_out <= data_reg; // Write to GPIO output
        end
    end
end

endmodule