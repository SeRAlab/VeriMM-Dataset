module PLL_8x (
    input wire clk_in,
    input wire enable,
    output reg clk_out
);
    reg [2:0] counter;
    
    always @(posedge clk_in) begin
        if (enable) begin
            counter <= counter + 1;
            if (counter == 3'd7) begin
                clk_out <= ~clk_out;
                counter <= 3'd0;
            end
        end
    end

    initial begin
        clk_out = 0;
        counter = 3'd0;
    end
endmodule