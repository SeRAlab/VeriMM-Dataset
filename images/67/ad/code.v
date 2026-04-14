module top_module(
    input clk,
    input EN,
    input RST,
    output reg [3:0] COUNT
);always @(posedge clk or negedge RST) begin
        if (RST == 0) begin
            COUNT <= 4'b0000;
        end
        else if (EN == 1) begin
            COUNT <= COUNT + 1;
        end
    end

endmodule