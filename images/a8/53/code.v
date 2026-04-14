module parallel_to_serial#(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire rst,
    input wire load,
    input wire en,
    input wire [WIDTH-1:0] parallel_in,
    output wire serial_out
);

reg [WIDTH-1:0] shift_reg;

always @(posedge clk or negedge rst) begin
    if (~rst) begin
        shift_reg <= 0;
    end else if (load) begin
        shift_reg <= parallel_in;
    end else if (en) begin
        shift_reg <= {shift_reg[WIDTH-2:0], 1'b0};
    end
end

assign serial_out = shift_reg[WIDTH-1];

endmodule