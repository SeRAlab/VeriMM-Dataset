module barrel_shifter#(
    parameter WIDTH = 8
)(
    input wire [WIDTH-1:0] data_in,
    input wire [$clog2(WIDTH)-1:0] shift_amount,
    input wire shift_dir,
    output reg [WIDTH-1:0] data_out
);

always @(*) begin
    if (shift_dir == 0) begin
        data_out = data_in << shift_amount;
    end else begin
        data_out = data_in >> shift_amount;
    end
end

endmodule