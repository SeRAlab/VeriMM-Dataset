module top_module(
    input [1:0] in,
    output out0, out1, out2, out3
    );reg [3:0] out;

assign out0 = out[0];
assign out1 = out[1];
assign out2 = out[2];
assign out3 = out[3];

always @ (*)
    case (in)
    2'b00: out = 4'b0001;
    2'b01: out = 4'b0010;
    2'b10: out = 4'b0100;
    2'b11: out = 4'b1000;
    endcase

endmodule