module pll (
    input wire clk_in,
    input wire reset,
    output reg clk_out
);

    reg [1:0] counter;

    always @(posedge clk_in or posedge reset) begin
        if (reset) begin
            clk_out <= 0;
            counter <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 2'b11) begin
                clk_out <= ~clk_out;
                counter <= 0;
            end
        end
    end
endmodule