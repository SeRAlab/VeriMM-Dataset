module top_module(
    input rst_n, sck, cs,
    input [31:0] sum,
    output reg miso
);reg [4:0] i;

always @(negedge rst_n or posedge cs or negedge sck) begin
    if (~rst_n) begin
        miso <= 1'b0;
        i <= 5'b11111;
    end else if (cs) begin
        miso <= 1'b0;
        i <= 5'b11111;
    end else begin
        miso <= sum[i];
        i <= i - 5'b1;
    end
end

endmodule