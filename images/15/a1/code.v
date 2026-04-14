module frequency_divider #(parameter DIVISOR = 2) (
    input wire clk,
    input wire reset,
    output reg divided_clk
);
    reg [31:0] counter;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            divided_clk <= 0;
        end else if (counter == (DIVISOR - 1)) begin
            divided_clk <= ~divided_clk;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule