module pll (
    input wire clk_in,
    input wire rst,
    output reg clk_out
);
    parameter MULTIPLIER = 2; // Can be set to 2, 4, or 8
    reg [31:0] counter;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            if (counter < (MULTIPLIER - 1)) begin
                counter <= counter + 1;
            end else begin
                counter <= 0;
                clk_out <= ~clk_out; // Toggle the output clock
            end
        end
    end
endmodule