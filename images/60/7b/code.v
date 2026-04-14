module top_module(
            input [bits:0] a,
            input [bits:0] b,
            output [bits:0] a_shift,
            output [bits:0] b_shift
    );parameter bits = 32;
    
    reg [bits:0] a_shift_reg;
    reg [bits:0] b_shift_reg;
    
    always @(a or b)
    begin
        a_shift_reg = {a[bits:bits-1],a[bits-1],a[bits-2:1]};
        b_shift_reg = {a[0],b[bits:1]};
    end
    
    assign a_shift = a_shift_reg;
    assign b_shift = b_shift_reg;
    
endmodule