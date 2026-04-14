module gray_code_counter_6bit(
    input wire clk,
    input wire rst,
    output reg [5:0] count
    );

reg [5:0] binary_count;

always @(posedge clk) begin
    if (rst)
        binary_count <= 6'b000000;
    else
        binary_count <= binary_count + 1;
end

always @(posedge clk) begin
    if (rst)
        count <= 6'b000000;
    else
        count <= (binary_count >> 1) ^ binary_count;
end

endmodule