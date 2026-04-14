module top_module(
    input [3:0] in,
    output reg out
);reg [1:0] select;

always @* begin
    case(in)
        4'b0001: select = 2'b00;
        4'b0010: select = 2'b01;
        4'b0100: select = 2'b10;
        4'b1000: select = 2'b11;
        default: select = 2'b00;
    endcase
end

always @* begin
    case(select)
        2'b00: out = in[0];
        2'b01: out = in[1];
        2'b10: out = in[2];
        2'b11: out = in[3];
        default: out = 1'b0;
    endcase
end

endmodule