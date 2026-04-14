module compare_numbers_module(
    input wire clk,
    input wire reset,
    input wire [7:0] binary_num1,
    input wire [7:0] binary_num2,
    output reg is_equal
);

    always @(posedge clk) begin
        if (reset) begin
            is_equal <= 0;
        end else begin
            if (binary_num1 == binary_num2) begin
                is_equal <= 1;
            end else begin
                is_equal <= 0;
            end
        end
    end

endmodule