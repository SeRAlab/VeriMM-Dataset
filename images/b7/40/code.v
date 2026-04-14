module subtractor_32bit (
    input wire [31:0] a,
    input wire [31:0] b,
    input wire Bin,
    output wire [31:0] y,
    output wire Bout
);
    
    wire Bout_temp;
    
    subtractor_16bit subtractor_16bit_inst1 (
        .a(a[31:16]),
        .b(b[31:16]),
        .Bin(Bout_temp), 
        .y(y[31:16]),
        .Bout(Bout)
    );
    
    subtractor_16bit subtractor_16bit_inst2 (
        .a(a[15:0]),
        .b(b[15:0]),
        .Bin(Bin),
        .y(y[15:0]),
        .Bout(Bout_temp)
    ); 
    
endmodule

module subtractor_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire Bin,
    output wire [15:0] y,
    output wire Bout
);
    
    wire Bout_temp;
    
    sub8 sub8_inst1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Bin(Bout_temp), 
        .y(y[15:8]),
        .Bout(Bout)
    );
    
    sub8 sub8_inst2 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Bin(Bin),
        .y(y[7:0]),
        .Bout(Bout_temp)
    ); 
    
endmodule

module sub8 (
    input wire [7:0] a,
    input wire [7:0] b,
    input wire Bin,
    output wire [7:0] y,
    output wire Bout
);
    
    wire Bout_temp;
    
    sub4 sub4_inst1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Bin(Bout_temp),
        .y(y[7:4]),
        .Bout(Bout)
    );
    
    sub4 sub4_inst2 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Bin(Bin),
        .y(y[3:0]),
        .Bout(Bout_temp)
    );
    
endmodule

module sub4 (
    input wire [3:0] a,
    input wire [3:0] b,
    input wire Bin,
    output wire [3:0] y,
    output wire Bout
);
    
    wire Bout_temp;
    
    sub2 sub2_inst1 (
        .a(a[3:2]),
        .b(b[3:2]),
        .Bin(Bout_temp),
        .y(y[3:2]),
        .Bout(Bout)
    );
    
    sub2 sub2_inst2 (
        .a(a[1:0]),
        .b(b[1:0]),
        .Bin(Bin),
        .y(y[1:0]),
        .Bout(Bout_temp)
    ); 
    
endmodule

module sub2 (
    input wire [1:0] a,
    input wire [1:0] b,
    input wire Bin,
    output wire [1:0] y,
    output wire Bout
);
    
    wire Bout_temp;

    sub1 sub1_inst1 (
        .a(a[1]),
        .b(b[1]),
        .Bin(Bout_temp),
        .y(y[1]),
        .Bout(Bout)
    );
    
    sub1 sub1_inst2 (
        .a(a[0]),
        .b(b[0]),
        .Bin(Bin),
        .y(y[0]),
        .Bout(Bout_temp)
    );
         
endmodule

module sub1 (
    input wire a,
    input wire b,
    input wire Bin,
    output wire y,
    output wire Bout
);
    assign y = a ^ b ^ Bin;
    assign Bout = (~a & b) | ((~a | b) & Bin);

endmodule