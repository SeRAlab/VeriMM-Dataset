module pll_2x (
    input wire clk_in,
    input wire rst,
    output reg clk_out
);
    reg [1:0] counter;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 2'b00;
            clk_out <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 2'b01) begin
                clk_out <= ~clk_out;
            end
        end
    end
endmodule