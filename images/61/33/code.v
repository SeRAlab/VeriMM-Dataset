module top_module(
    input reset,
    input counting,
    input enable,
    input clk,
    output reg [17:0] count
    );always @(posedge clk)
    begin
        if (reset == 1'b0)
            count <= 0;
        else if (counting == 1'b1 && enable == 1'b1)
            count <= count + 1'b1;
        else if (enable == 1'b0)
            count <= 1'b0;
    end

endmodule