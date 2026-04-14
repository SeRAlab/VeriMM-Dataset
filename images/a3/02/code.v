module top_module(
    input        clk,
    input        clr,
    input  [3:0] A,
    input  [3:0] B,
    input        sub,
    output [3:0] Y
);reg [3:0] temp;
    
    always @(posedge clk)
        if (clr) temp <= 4'b0;
        else if (sub) temp <= A - B;
        else temp <= A + B;
    
    assign Y = temp;

endmodule