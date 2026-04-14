module top_module(
    input [15:0] entrada,
    input clk,
    input load,
    output reg [15:0] saida
);always @(posedge clk) begin
        if (load == 1) begin
           saida <= entrada;
        end
    end
endmodule