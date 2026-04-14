module gray_counter(
    input wire clk,
    input wire rst_n,
    output reg [2:0] gray_out
    );

reg [2:0] bin_count;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        bin_count <= 3'b000;
        gray_out <= 3'b000;
    end else begin
        bin_count <= bin_count + 1;
        gray_out <= bin_count ^ (bin_count >> 1);
    end
end

endmodule