module toggle_ff(
    input clk,
    input rst_n,
    output reg [15:0] q
);
    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            q <= 16'b0000000000000000;
        end else begin
            q <= ~q;
        end
    end
endmodule