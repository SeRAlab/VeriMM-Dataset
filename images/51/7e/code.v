module xor_32bit (
    input wire [31:0] a,
    input wire [31:0] b,
    output wire [31:0] y
);

    xor_16bit xor_16bit_inst1 (
        .a(a[31:16]),
        .b(b[31:16]),
        .y(y[31:16])
    );
    
    xor_16bit xor_16bit_inst2 (
        .a(a[15:0]),
        .b(b[15:0]),
        .y(y[15:0])
    ); 
    
endmodule

module xor_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    output wire [15:0] y
);

    xor8 xor8_inst1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .y(y[15:8])
    );
    
    xor8 xor8_inst2 (
        .a(a[7:0]),
        .b(b[7:0]),
        .y(y[7:0])
    ); 
    
endmodule

module xor8 (
    input wire [7:0] a,
    input wire [7:0] b,
    output wire [7:0] y
);

    xor4 xor4_inst1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .y(y[7:4])
    );
    
    xor4 xor4_inst2 (
        .a(a[3:0]),
        .b(b[3:0]),
        .y(y[3:0])
    ); 
    
endmodule

module xor4 (
    input wire [3:0] a,
    input wire [3:0] b,
    output wire [3:0] y
);

    xor2 xor2_inst1 (
        .a(a[3:2]),
        .b(b[3:2]),
        .y(y[3:2])
    );
    
    xor2 xor2_inst2 (
        .a(a[1:0]),
        .b(b[1:0]),
        .y(y[1:0])
    ); 
    
endmodule

module xor2 (
    input wire [1:0] a,
    input wire [1:0] b,
    output wire [1:0] y
);

    xor1 xor1_inst1 (
        .a(a[1]),
        .b(b[1]),
        .y(y[1])
    );
    
    xor1 xor1_inst2 (
        .a(a[0]),
        .b(b[0]),
        .y(y[0])
    ); 
    
endmodule

module xor1 (
    input wire a,
    input wire b,
    output wire y
);
    assign y = a ^ b;
endmodule