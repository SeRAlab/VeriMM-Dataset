module binary_adder (
    A   ,
    B   ,
    Cin ,
    En  ,
    S   ,
    Cout
);

    input  [3:0] A   ;
    input  [3:0] B   ;
    input        Cin ;
    input        En  ;
    output [3:0] S   ;
    output       Cout;

    wire [3:0] sum;
    wire [3:0] carry;

    assign sum = A + B + Cin;
    assign Cout = carry[3];

    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin
            assign carry[i+1] = (sum[i+1] > 1) ? 1 : 0;
        end
    endgenerate

    assign S = En ? sum : 4'b0000;

endmodule