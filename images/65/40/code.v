module top_module(
    input clk,
    input reset_n,
    input en,
    output reg[3:0] count
);always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            count <= 4'b0000;
        end
        else if (en) begin
            count <= count + 1;
        end
    end

endmodule