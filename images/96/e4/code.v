module gray_code_counter (
    input clk,
    input rst_n,
    input en,
    output reg [4:0] gray_count
);

reg [4:0] binary_count;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        binary_count <= 5'b00000;
        gray_count <= 5'b00000;
    end else if (en) begin
        binary_count <= binary_count + 1;
        gray_count <= binary_count ^ (binary_count >> 1);
    end
end

endmodule