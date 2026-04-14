module gray_counter(
    input wire clk,
    input wire rst,
    output reg [5:0] gray_out
);

reg [5:0] binary_count;

always @(posedge clk) begin
    if (rst) begin
        binary_count <= 6'b000000;
        gray_out <= 6'b000000;
    end else begin
        binary_count <= binary_count + 1;
        gray_out <= binary_count ^ (binary_count >> 1);
    end
end

endmodule