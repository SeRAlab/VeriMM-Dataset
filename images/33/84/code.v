module clock_divider #(parameter N = 4) (
    input wire clk,
    input wire rst,
    output reg clk_out
);
    reg [N-1:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_out <= 0;
        end else if (counter == (N-1)) begin
            counter <= 0;
            clk_out <= ~clk_out;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule