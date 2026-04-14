module gpio_controller (
    input wire clk,
    input wire enable,
    input wire [2:0] control,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg [7:0] gpio_out
);

    always @(posedge clk) begin
        if (enable) begin
            data_out <= data_in;
            case (control)
                3'b001: gpio_out[0] <= 1'b1;
                3'b010: gpio_out[1] <= 1'b1;
                3'b011: gpio_out[2] <= 1'b1;
                3'b100: gpio_out[3] <= 1'b1;
                3'b101: gpio_out[4] <= 1'b1;
                3'b110: gpio_out[5] <= 1'b1;
                3'b111: gpio_out[6] <= 1'b1;
                default: gpio_out <= 8'b00000000;
            endcase
        end
    end
endmodule