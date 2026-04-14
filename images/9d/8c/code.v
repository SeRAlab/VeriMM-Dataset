module bitwise_and_module(
    input wire clk,
    input wire reset,
    input wire [3:0] binary_num1,
    input wire [3:0] binary_num2,
    output reg [3:0] and_result
);

    always @(posedge clk) begin
        if (reset) begin
            and_result <= 0;
        end else begin
            and_result <= binary_num1 & binary_num2;
        end
    end

endmodule