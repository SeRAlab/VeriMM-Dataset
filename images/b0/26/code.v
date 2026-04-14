module top_module(
    input clk,                     // Added clk input
    input [15:0] data_in,
    output reg [7:0] crc_out
);reg [15:0] shift_reg;
reg [15:0] crc_poly = 16'h1021;

always @(posedge clk) begin
    shift_reg <= {shift_reg[14:0], data_in[15]};
    if (shift_reg[15]) begin
        shift_reg <= shift_reg ^ crc_poly;
    end
end

assign crc_out = shift_reg[7:0];

endmodule