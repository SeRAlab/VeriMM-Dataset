module sync_up_down_counter(
    input clk,
    input rst,
    input en,
    input dir,
    output reg [7:0] q
    );

    always @(posedge clk) begin
        if (rst) begin
            q <= 8'b00000000;
        end else if (en) begin
            if (dir) begin
                q <= q + 1;
            end else begin
                q <= q - 1;
            end
        end
    end
endmodule