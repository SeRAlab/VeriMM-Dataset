module top_module(
    input [7:0] binary_number,
    output reg [15:0] decimal_number // Change wire to reg to allow assignment in always block
);wire [6:0] absolute_value;
    wire [15:0] decimal_value;

    assign absolute_value = binary_number[6:0];
    assign decimal_value = {binary_number[7], absolute_value};

    always @(*) begin
        if (binary_number[7] == 1) begin
            decimal_number = ~(decimal_value) + 1;
        end else begin
            decimal_number = decimal_value;
        end
    end

endmodule