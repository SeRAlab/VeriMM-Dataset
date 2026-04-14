module gpio_controller (
    input wire clk,
    input wire rst,
    input wire [4:0] gpio_in,
    input wire write_enable,
    output reg [4:0] gpio_out,
    output reg write_success
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            gpio_out <= 5'b00000;
            write_success <= 1'b0;
        end else begin
            if (write_enable) begin
                gpio_out <= gpio_in;
                write_success <= 1'b1;
            end else begin
                write_success <= 1'b0;
            end
        end
    end
endmodule