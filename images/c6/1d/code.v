module bin_to_gray(
    input clk,
    input rst,
    input [3:0] bin,
    output reg [3:0] gray
);

always @(posedge clk) begin
    if (rst) begin
        gray <= 4'b0000;
    end else begin
        gray <= bin ^ (bin >> 1);
    end
end

endmodule