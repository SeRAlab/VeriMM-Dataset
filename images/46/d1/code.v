module parallel_to_serial#(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire rst,
    input wire en,
    input wire start,
    input wire [WIDTH-1:0] parallel_in,
    output reg serial_out,
    output reg busy
);

reg [WIDTH-1:0] shift_reg;
reg [$clog2(WIDTH):0] bit_count;

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        shift_reg <= 0;
        bit_count <= 0;
        busy <= 0;
    end else if (en) begin
        if (start && ~busy) begin
            shift_reg <= parallel_in;
            bit_count <= 0;
            busy <= 1;
        end else if (busy) begin
            serial_out <= shift_reg[0];
            shift_reg <= shift_reg >> 1;
            bit_count <= bit_count + 1;
            if (bit_count == WIDTH-1) begin
                busy <= 0;
            end
        end
    end
end

endmodule