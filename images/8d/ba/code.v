module nor_32bit (
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] y
);

    nor_16bit nor_16bit_inst1 (
        .a(a[31:16]),
        .b(b[31:16]),
        .y(y[31:16])
    );
    
    nor_16bit nor_16bit_inst2 (
        .a(a[15:0]),
        .b(b[15:0]),
        .y(y[15:0])
    ); 
    
endmodule

module nor_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    output wire [15:0] y
);

    nor8 nor8_inst1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .y(y[15:8])
    );
    
    nor8 nor8_inst2 (
        .a(a[7:0]),
        .b(b[7:0]),
        .y(y[7:0])
    ); 
    
endmodule

module nor8 (
    input wire [7:0] a,
    input wire [7:0] b,
    output wire [7:0] y
);

    nor4 nor4_inst1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .y(y[7:4])
    );
    
    nor4 nor4_inst2 (
        .a(a[3:0]),
        .b(b[3:0]),
        .y(y[3:0])
    ); 
    
endmodule

module nor4 (
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [3:0] y
);

    nor2 nor2_inst1 (
        .a(a[3:2]),
        .b(b[3:2]),
        .y(y[3:2])
    );
    
    nor2 nor2_inst2 (
        .a(a[1:0]),
        .b(b[1:0]),
        .y(y[1:0])
    ); 
    
endmodule

module nor2 (
    input wire [1:0] a,
    input wire [1:0] b,
    output wire [1:0] y
);

    nor1 nor1_inst1 (
        .a(a[1]),
        .b(b[1]),
        .y(y[1])
    );
    
    nor1 nor1_inst2 (
        .a(a[0]),
        .b(b[0]),
        .y(y[0])
    ); 
    
endmodule

module nor1 (
    input wire a,
    input wire b,
    output wire y
);
    assign y = ~(a | b);
endmodule