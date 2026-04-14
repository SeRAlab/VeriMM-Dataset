module serializer (
    input wire clk,
    input wire rst,
    input wire en,
    input wire [7:0] parallel_in,
    output reg serial_out
);
    reg [2:0] bit_count; // 3 bits to count 8 bits
    reg [7:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            bit_count <= 3'b000;
            serial_out <= 0;
            shift_reg <= 8'b00000000;
        end else if (en) begin
            if (bit_count < 8) begin
                serial_out <= shift_reg[0]; // output LSB first
                shift_reg <= {1'b0, shift_reg[7:1]}; // shift right
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'b000; // reset count after 8 bits
                shift_reg <= parallel_in; // load new data
            end
        end
    end
endmodule