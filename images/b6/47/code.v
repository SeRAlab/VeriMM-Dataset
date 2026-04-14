module top_module(
    input [3:0] data_in,
    input [3:0] in_0,
    input [3:0] in_1,
    input [3:0] in_2,
    input [3:0] in_3,
    input [1:0] sel,
    input shift,
    output reg [3:0] out
);reg [3:0] shift_reg;

always @ (posedge shift) begin
    shift_reg <= {shift_reg[2:0], data_in[0]};
end

always @ (*) begin
    case (sel)
        2'b00: shift_reg <= in_0;
        2'b01: shift_reg <= in_1;
        2'b10: shift_reg <= in_2;
        2'b11: shift_reg <= in_3;
    endcase
end

assign out = shift_reg;

endmodule