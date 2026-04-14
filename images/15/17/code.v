module serializer(
    input wire clk,
    input wire start,
    input wire [7:0] data_in,
    output reg serial_out,
    output reg done
);
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk) begin
        if (start) begin
            shift_reg <= data_in;
            bit_count <= 3'b000;
            done <= 0;
        end else if (bit_count < 3'b111) begin
            serial_out <= shift_reg[0];
            shift_reg <= shift_reg >> 1;
            bit_count <= bit_count + 1;
        end else begin
            done <= 1;
        end
    end
endmodule