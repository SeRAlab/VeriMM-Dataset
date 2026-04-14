module fibonacci(
    input clk,
    input reset,
    output reg [7:0] out
);

reg [7:0] a, b, c;
reg [3:0] cnt;

always @(posedge clk) begin
    if (reset) begin
        a <= 8'h01;
        b <= 8'h01;
        c <= 8'h00;
        cnt <= 4'h0;
    end else begin
        c <= a + b;
        a <= b;
        b <= c;
        if (cnt == 4'hB) begin
            out <= c;
            cnt <= 4'h0;
        end else begin
            cnt <= cnt + 1;
        end
    end
end

endmodule