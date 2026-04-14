module sync_down_counter_6bit(
    input clk,
    input rst,
    output reg [5:0] q
    );

    always @(posedge clk) begin
        if (rst) begin
            q <= 6'b111111;
        end else begin
            q <= q - 1;
        end
    end
endmodule