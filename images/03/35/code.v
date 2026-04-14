module serializer (
    input clk,
    input rst,
    input valid,
    input [7:0] parallel_in,
    output reg serial_out
);
    reg [3:0] bit_counter;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            serial_out <= 0;
            bit_counter <= 0;
            shift_reg <= 0;
        end else if (valid) begin
            shift_reg <= parallel_in;
            bit_counter <= 0; // Reset counter for new input
        end else if (bit_counter < 8) begin
            serial_out <= shift_reg[bit_counter];
            bit_counter <= bit_counter + 1;
        end
    end
endmodule