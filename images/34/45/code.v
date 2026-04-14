module crystal_oscillator (
    input wire clk,
    input wire clk_enable,
    output reg out
);
    always @(posedge clk) begin
        if (clk_enable) begin
            out <= ~out;
        end
    end
endmodule