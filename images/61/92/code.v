module gray_code_counter #(
    parameter WIDTH = 4
) (
    input wire clk,
    input wire rst,
    output reg [WIDTH-1:0] gray_code
);

reg [WIDTH-1:0] binary_count;

always @(posedge clk) begin
    if (rst) begin
        binary_count <= 0;
    end else begin
        binary_count <= binary_count + 1;
    end
    gray_code <= binary_count ^ (binary_count >> 1);
end

endmodule