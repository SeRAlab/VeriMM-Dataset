module gpio_controller (
    input wire [3:0] gpio_in,
    input wire enable,
    output reg [3:0] gpio_out
);
    
    always @(posedge enable) begin
        gpio_out <= gpio_in;
    end

endmodule