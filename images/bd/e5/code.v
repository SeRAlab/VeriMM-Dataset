module top_module(
    clk,
    rst_n,
    in,
    out
);input   clk, rst_n;
input   [29:0] in;
output  reg [29:0] out;

always@(posedge clk)begin
    if (rst_n==0) begin
        out <= 0;
    end
    else begin
        out <= in;
    end
end

endmodule