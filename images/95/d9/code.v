module top_module(
    input [1:0] sw,
    output [3:0] led
    );reg [3:0] H;
assign led = H;
always @(sw)
    case(sw)
    2'b00: H=4'b0001; 
    2'b01: H=4'b0010;
    2'b10: H=4'b0100;
    2'b11: H=4'b1000;
    endcase

endmodule