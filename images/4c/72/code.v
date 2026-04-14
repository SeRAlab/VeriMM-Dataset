module and_32bit (
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] y
);

    and_16bit and_16bit_inst1 (
        .a(a[31:16]),
        .b(b[31:16]),
        .y(y[31:16])
    );
    
    and_16bit and_16bit_inst2 (
        .a(a[15:0]),
        .b(b[15:0]),
        .y(y[15:0])
    ); 
    
endmodule

module and_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    output wire [15:0] y
);

    and8 and8_inst1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .y(y[15:8])
    );
    
    and8 and8_inst2 (
        .a(a[7:0]),
        .b(b[7:0]),
        .y(y[7:0])
    ); 
    
endmodule

module and8 (
    input wire [7:0] a,
    input wire [7:0] b,
    output wire [7:0] y
);

    and4 and4_inst1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .y(y[7:4])
    );
    
    and4 and4_inst2 (
        .a(a[3:0]),
        .b(b[3:0]),
        .y(y[3:0])
    ); 
    
endmodule

module and4 (
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [3:0] y
);

    and2 and2_inst1 (
        .a(a[3:2]),
        .b(b[3:2]),
        .y(y[3:2])
    );
    
    and2 and2_inst2 (
        .a(a[1:0]),
        .b(b[1:0]),
        .y(y[1:0])
    ); 
    
endmodule

module and2 (
    input wire [1:0] a,
    input wire [1:0] b,
    output wire [1:0] y
);

    and1 and1_inst1 (
        .a(a[1]),
        .b(b[1]),
        .y(y[1])
    );
    
    and1 and1_inst2 (
        .a(a[0]),
        .b(b[0]),
        .y(y[0])
    ); 
    
endmodule

module and1 (
    input wire a,
    input wire b,
    output wire y
);
    assign y = a & b;
endmodule