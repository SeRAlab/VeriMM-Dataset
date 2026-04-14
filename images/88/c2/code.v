module async_reset_down_counter(
    input clk,
    input rst,
    input en,
    output reg [3:0] q
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 4'b1111;
        end else if (en) begin
            q <= q - 1;
        end
    end
endmodule