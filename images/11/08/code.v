module frequency_divider (
    input wire clk_in,
    input wire enable,
    output reg clk_out
);
    reg [1:0] count;

    always @(posedge clk_in) begin
        if (enable) begin
            count <= count + 1;
            if (count == 2'b01) begin
                clk_out <= ~clk_out;
                count <= 2'b00;
            end
        end
    end

    initial begin
        clk_out = 0;
        count = 0;
    end
endmodule