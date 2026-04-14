module serializer(
    input clk,
    input reset,
    input start,
    input [31:0] data_in,
    output reg serial_out,
    output reg done
);
    reg [5:0] bit_counter; // Counter to keep track of bits serialized
    reg [31:0] shift_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bit_counter <= 6'b0;
            shift_reg <= 32'b0;
            serial_out <= 1'b0;
            done <= 1'b0;
        end else if (start) begin
            shift_reg <= data_in;
            bit_counter <= 6'b0;
            done <= 1'b0;
        end else if (bit_counter < 32) begin
            serial_out <= shift_reg[bit_counter];
            bit_counter <= bit_counter + 1;
        end else begin
            done <= 1'b1;
        end
    end
endmodule