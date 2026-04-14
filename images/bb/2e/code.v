module sync_down_counter_with_enable(
    input clk,
    input rst,
    input en,
    output reg [3:0] q
    );

    always @(posedge clk) begin
        if (rst) begin
            q <= 4'b1111;
        end else if (en) begin
            q <= q - 1;
        end
    end
endmodule