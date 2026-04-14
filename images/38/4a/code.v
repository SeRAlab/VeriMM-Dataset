module gpio_controller (
    input wire clk,
    input wire we,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

    reg [7:0] gpio_reg;

    always @(posedge clk) begin
        if (we) begin
            gpio_reg <= data_in;
        end
        data_out <= gpio_reg;
    end
endmodule