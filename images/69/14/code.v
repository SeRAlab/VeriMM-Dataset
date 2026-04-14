module up_down_counter(
    input clk,
    input rst,
    input en,
    input up,
    output reg [9:0] q
    );

    always @(posedge clk) begin
        if (rst) begin
            q <= 10'b0;
        end else if (en) begin
            if (up) begin
                q <= q + 1;
            end else begin
                q <= q - 1;
            end
        end
    end
endmodule