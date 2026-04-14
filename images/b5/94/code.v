module bidirectional_shift_register#(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire rst,
    input wire en,
    input wire shift_left,
    input wire data_in,
    output wire [WIDTH-1:0] data_out
);

reg [WIDTH-1:0] shift_reg;

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        shift_reg <= 0;
    end else if (en) begin
        if (shift_left) begin
            shift_reg <= {shift_reg[WIDTH-2:0], data_in};
        end else begin
            shift_reg <= {data_in, shift_reg[WIDTH-1:1]};
        end
    end
end

assign data_out = shift_reg;

endmodule