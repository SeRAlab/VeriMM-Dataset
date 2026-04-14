module clock_divider (
    input wire clk,
    input wire rst,
    output reg clk_out
);
    reg [1:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_out <= 0;
        end else begin
            counter <= counter + 1;
            if (counter == 3) begin
                clk_out <= ~clk_out;
                counter <= 0;
            end
        end
    end
endmodule