module sync_up_down_counter(
    input clk,
    input rst,
    input dir,
    output reg [3:0] q
    );

    always @(posedge clk) begin
        if (rst) begin
            q <= 4'b0000;
        end else if (dir) begin
            q <= q + 1;
        end else begin
            q <= q - 1;
        end
    end
endmodule