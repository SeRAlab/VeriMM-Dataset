module top_module(
    input [15:0] in,
    input [1:0] ctrl,
    output [15:0] out
);reg [15:0] temp;

always @*
begin
    case (ctrl)
        2'b00: temp = in;
        2'b01: temp = ~in;
        2'b10: temp = {in[13:0], 2'b00};
        2'b11: temp = {2'b00, in[15:2]};
    endcase
end

assign out = temp;

endmodule