module top_module(
    output reg [15:0] o_2selA,
    input [15:0] i_selB,
    input [15:0] i_acc,
    input i_op
    );always @*
    begin
        if (i_op)
            o_2selA = i_selB + i_acc;
        else
            o_2selA = i_acc - i_selB;
    end
    
endmodule