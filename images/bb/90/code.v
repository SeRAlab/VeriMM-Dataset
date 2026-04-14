module serial_to_parallel#(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire rst,
    input wire shift,
    input wire en,
    input wire serial_in,
    output wire [WIDTH-1:0] parallel_out,
    output wire data_valid
);

reg [WIDTH-1:0] shift_reg;
reg [3:0] bit_count;

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        shift_reg <= 0;
        bit_count <= 0;
    end else if (shift && en) begin
        shift_reg <= {shift_reg[WIDTH-2:0], serial_in};
        if (bit_count == WIDTH-1) begin
            bit_count <= 0;
        end else begin
            bit_count <= bit_count + 1;
        end
    end
end

assign parallel_out = shift_reg;
assign data_valid = (bit_count == WIDTH-1);

endmodule