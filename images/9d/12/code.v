module adder_32bit (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire Cin,
    output wire [31:0] sum,
    output wire Cout
);
    
    wire Cout_temp;
    
    adder_16bit adder_16bit_inst1 (
        .a(a[31:16]),
        .b(b[31:16]),
        .Cin(Cout_temp), 
        .sum(sum[31:16]),
        .Cout(Cout)
    );
    
    adder_16bit adder_16bit_inst2 (
        .a(a[15:0]),
        .b(b[15:0]),
        .Cin(Cin),
        .sum(sum[15:0]),
        .Cout(Cout_temp)
    ); 
    
endmodule

module adder_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Cin,
    output wire [15:0] sum,
    output wire Cout
);
    
    wire Cout_temp;
    
    add8 add8_inst1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Cout_temp), 
        .sum(sum[15:8]),
        .Cout(Cout)
    );
    
    add8 add8_inst2 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(sum[7:0]),
        .Cout(Cout_temp)
    ); 
    
endmodule

module add8 (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Cin,
    output wire [7:0] sum,
    output wire Cout
);
    
    wire Cout_temp;
    
    add4 add4_inst1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(Cout_temp),
        .sum(sum[7:4]),
        .Cout(Cout)
    );
    
    add4 add4_inst2 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .sum(sum[3:0]),
        .Cout(Cout_temp)
    );
    
endmodule

module add4 (
    input wire [3:0] a,
    input wire [3:0] b,
    input wire Cin,
    output wire [3:0] sum,
    output wire Cout
);
    
    wire Cout_temp;
    
    add2 add2_inst1 (
        .a(a[3:2]),
        .b(b[3:2]),
        .Cin(Cout_temp),
        .sum(sum[3:2]),
        .Cout(Cout)
    );
    
    add2 add2_inst2 (
        .a(a[1:0]),
        .b(b[1:0]),
        .Cin(Cin),
        .sum(sum[1:0]),
        .Cout(Cout_temp)
    ); 
    
endmodule

module add2 (
    input wire [1:0] a,
    input wire [1:0] b,
    input wire Cin,
    output wire [1:0] sum,
    output wire Cout
);
    
    wire Cout_temp;

    add1 add1_inst1 (
        .a(a[1]),
        .b(b[1]),
        .Cin(Cout_temp),
        .sum(sum[1]),
        .Cout(Cout)
    );
    
    add1 add1_inst2 (
        .a(a[0]),
        .b(b[0]),
        .Cin(Cin),
        .sum(sum[0]),
        .Cout(Cout_temp)
    );
         
endmodule

module add1 (
    input wire a,
    input wire b,
    input wire Cin,
    output wire sum,
    output wire Cout
);
    assign sum = a ^ b ^ Cin;
    assign Cout = (a & b) | ((a ^ b) & Cin);

endmodule