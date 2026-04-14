module gpio_controller(
    input wire clk,
    input wire rst_n,
    input wire [4:0] gpio_data,
    input wire [4:0] config_reg,
    output reg [4:0] gpio_output
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            gpio_output <= 5'b00000; // Reset output to 0
        end else begin
            gpio_output <= gpio_data & config_reg; // Output based on config reg
        end
    end
    
endmodule