module top_module(
    input [15:0] DATA,
    input [3:0] SHIFT,
    input [1:0] CTRL,
    output reg [15:0] out
);reg [15:0] shift_reg1, shift_reg2, shift_reg3;

always @(*) begin
    shift_reg1 = DATA;
    shift_reg2 = (CTRL == 2'b00) ? {DATA[14:0], 1'b0} :
                 (CTRL == 2'b01) ? {1'b0, DATA[15:1]} :
                 (CTRL == 2'b10) ? {{DATA[15], DATA[15:1]}, DATA[15]} :
                                   {DATA[0], DATA[15:1]};
    shift_reg3 = (SHIFT[3] == 1'b1) ? shift_reg2 :
                 (SHIFT[2] == 1'b1) ? shift_reg2 >> 2 :
                 (SHIFT[1] == 1'b1) ? shift_reg2 >> 4 :
                                      shift_reg2 >> 8;
    out = (SHIFT[0] == 1'b1) ? shift_reg3 :
          (SHIFT[1:0] == 2'b01) ? {shift_reg3[0], shift_reg3[15:1]} :
          (SHIFT[1:0] == 2'b10) ? {{shift_reg3[15], shift_reg3[15:1]}, shift_reg3[15]} :
                                   {shift_reg3[14:0], shift_reg3[0]};
end

endmodule