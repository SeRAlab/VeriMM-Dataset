module serial_to_parallel#(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire rst,
    input wire en,
    input wire serial_in,
    output reg [WIDTH-1:0] parallel_out,
    output reg valid
);

reg [WIDTH-1:0] shift_reg;
reg [$clog2(WIDTH):0] bit_count;

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        shift_reg <= 0;
        bit_count <= 0;
        valid <= 0;
    end else if (en) begin
        shift_reg <= {shift_reg[WIDTH-2:0], serial_in};
        bit_count <= bit_count + 1;
        if (bit_count == WIDTH-1) begin
            parallel_out <= {shift_reg[WIDTH-2:0], serial_in};
            valid <= 1;
        end else begin
            valid <= 0;
        end
    end
end

endmodule