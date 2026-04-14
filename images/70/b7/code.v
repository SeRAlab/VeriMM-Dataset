module gray_code_counter#(
    parameter WIDTH = 7
)(
    input wire clk,
    input wire rst,
    input wire en,
    input wire load,
    input wire [WIDTH-1:0] binary_value,
    output reg [WIDTH-1:0] gray_code
);

reg [WIDTH-1:0] binary_count;

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        binary_count <= 0;
        gray_code <= 0;
    end else if (load) begin
        binary_count <= binary_value;
        gray_code <= binary_value ^ (binary_value >> 1);
    end else if (en) begin
        binary_count <= binary_count + 1;
        gray_code <= (binary_count + 1) ^ ((binary_count + 1) >> 1);
    end
end

endmodule