module binary_counter (
    q,
    clk,
    rst
);

    output reg [3:0] q;
    input clk;
    input rst;

    always @(posedge clk) begin
        if (rst) begin
            q <= 4'b0000;
        end else begin
            q <= q + 1;
            if (q == 4'b1111) begin
                q <= 4'b0000;
            end
        end
    end

endmodule