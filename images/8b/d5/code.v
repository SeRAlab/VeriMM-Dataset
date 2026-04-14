module top_module(
    A   ,
    B   ,
    Cin ,
    Sum ,
    Cout,
    Clk
);input  [3:0] A   ;
    input  [3:0] B   ;
    input        Cin ;
    output [3:0] Sum ;
    output       Cout;
    input        Clk ;

    reg [3:0] Sum_;
    reg       Cout_;

    always @(posedge Clk) begin
        {Cout_, Sum_} <= A + B + Cin; // Simple addition operation for the four bits
    end

    assign Sum = Sum_;
    assign Cout = Cout_;

endmodule