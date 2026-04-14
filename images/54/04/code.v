module top_module(
    input Clk,ShiftIn,load,ShiftEn,
    input [3:0] ParallelIn,
    output ShiftOut, 
    output [3:0] RegContent
    );reg [3:0] shift_reg;
    always @(posedge Clk)
        if(load)
            shift_reg <= ParallelIn;
        else if (ShiftEn)
            shift_reg <= {shift_reg[2:0], ShiftIn};
    assign ShiftOut = shift_reg[3];
    assign RegContent = shift_reg;
endmodule