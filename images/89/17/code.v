module gray_code_counter(
    input wire clk,
    input wire rst,
    input wire en,
    output reg [3:0] count
);

reg [3:0] binary_count;

always @(posedge clk) begin
    if (~rst) begin
        binary_count <= 4'b0000;
        count <= 4'b0000;
    end else if (en) begin
        binary_count <= binary_count + 1;
        count <= binary_count ^ (binary_count >> 1);
    end
end

endmodule