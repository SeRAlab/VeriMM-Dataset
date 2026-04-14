module frequency_divider (
    input clk,
    output reg clk_out
);
    reg [1:0] count;

    always @(posedge clk) begin
        count <= count + 1;
        if (count == 2'b11) begin
            clk_out <= ~clk_out;
            count <= 2'b00;
        end
    end

    initial begin
        clk_out = 0;
        count = 2'b00;
    end
endmodule