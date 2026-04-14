module top_module(
    input               clk,
    input    [31:0]     in_data,
    
    output              gpio_sinal,
    output              mem_sinal
);reg                     gpio_reg;

always @(posedge clk)
begin
    if(in_data>1023) gpio_reg <= 1;
    else gpio_reg <= 0;
end

assign gpio_sinal = gpio_reg;
assign mem_sinal = ~gpio_reg;

endmodule