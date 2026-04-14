module top_module (
    input clk,
    input in,
    output reg rising_edge
);
    reg in_d;
    
    always @(posedge clk) begin
        in_d <= in;
        rising_edge <= in & ~in_d;
    end
endmodule