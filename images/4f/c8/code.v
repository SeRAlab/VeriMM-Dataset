module sync_down_counter_16bit(
    input clk,
    input rst,
    output reg [15:0] q
    );

    always @(posedge clk) begin
        if (rst) begin
            q <= 16'b1111111111111111;
        end else begin
            q <= q - 1;
        end
    end
endmodule