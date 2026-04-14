module gray_counter(
    input clk,
    input rst,
    input en,
    output reg [3:0] gray_count
);

reg [3:0] binary_count;

always @(posedge clk, posedge rst) begin
    if (rst) begin
        binary_count <= 4'b0000;
        gray_count <= 4'b0000;
    end else if (en) begin
        binary_count <= binary_count + 1;
        gray_count <= {binary_count[3], binary_count[3] ^ binary_count[2], binary_count[2] ^ binary_count[1], binary_count[1] ^ binary_count[0]};
    end
end

endmodule