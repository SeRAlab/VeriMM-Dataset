module sum_digits_module(
    input wire clk,
    input wire reset,
    input wire [3:0] binary_num,
    output reg [3:0] sum_digits
);

    integer i;
    
    always @(posedge clk) begin
        if (reset) begin
            sum_digits <= 0;
        end else begin
            sum_digits <= 0;
            for (i = 0; i < 4; i = i + 1) begin
                sum_digits <= sum_digits + binary_num[i];
            end
        end
    end

endmodule