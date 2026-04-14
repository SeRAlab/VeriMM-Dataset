module gray_code_counter_4bit (
    input wire clk,
    input wire rst,
    output reg [3:0] gray
    );

reg [3:0] binary_count;

always @(posedge clk) begin
    if (rst) begin
        binary_count <= 4'b0000;
    end else begin
        binary_count <= binary_count + 1;
    end
end

always @(*) begin
    gray = (binary_count >> 1) ^ binary_count;
end

endmodule