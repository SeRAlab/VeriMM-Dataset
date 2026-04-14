module top_module (
    input clk,
    output reg clk_out
);
    reg state = 0;
    always @(posedge clk) begin
        state <= ~state;
        clk_out <= state;
    end
endmodule