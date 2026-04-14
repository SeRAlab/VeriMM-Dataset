module serializer (
    input wire clk,
    input wire start,
    input wire [7:0] parallel_in,
    output reg serial_out,
    output reg done
);
    reg [3:0] bit_index;
    reg [7:0] data_reg;

    always @(posedge clk) begin
        if (start) begin
            data_reg <= parallel_in;
            bit_index <= 0;
            done <= 0;
        end else if (bit_index < 8) begin
            serial_out <= data_reg[7 - bit_index];
            bit_index <= bit_index + 1;
        end else begin
            done <= 1;
        end
    end
endmodule