module add_numbers_module(
    input wire clk,
    input wire reset,
    input wire [3:0] binary_num1,
    input wire [3:0] binary_num2,
    output reg [4:0] sum
);

    always @(posedge clk) begin
        if (reset) begin
            sum <= 0;
        end else begin
            sum <= binary_num1 + binary_num2;
        end
    end

endmodule