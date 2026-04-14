module gpio_controller(
    input wire [4:0] gpio_in,
    input wire wr_en,
    input wire clk,
    output reg [4:0] gpio_out
);
    always @(posedge clk) begin
        if (wr_en) begin
            gpio_out <= gpio_in;
        end
    end
endmodule