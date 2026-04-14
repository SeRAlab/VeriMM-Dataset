module sync_up_down_counter_12bit(
    input clk,
    input rst,
    input up,
    input en,
    output reg [11:0] q
    );

    always @(posedge clk) begin
        if (rst) begin
            q <= 12'b000000000000;
        end else if (en) begin
            if (up) begin
                q <= q + 1;
            end else begin
                q <= q - 1;
            end
        end
    end
endmodule