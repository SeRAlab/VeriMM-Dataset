module top_module (
    input clk,
    output reg clk_div4
);

    reg [1:0] count;

    always @(posedge clk) begin
        count <= count + 1;
        if (count == 2'b11)
            clk_div4 <= ~clk_div4;
    end

endmodule