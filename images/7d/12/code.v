module sync_up_down_counter(
    input clk,
    input rst,
    input up,
    output reg [15:0] q
    );

    always @(posedge clk) begin
        if (rst) begin
            q <= 16'b0000000000000000;
        end else if (up) begin
            q <= q + 1;
        end else begin
            q <= q - 1;
        end
    end
endmodule