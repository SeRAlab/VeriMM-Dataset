module top_module(
    Y   ,
    overflow_flag,
    A1_N,
    A2_N,
    B1  ,
    B2,
    VPWR
);output [1:0] Y;               // Changed to 2-bit output
    output overflow_flag;
    input  A1_N;
    input  A2_N;
    input  B1;
    input  B2;
    input  VPWR;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    wire [2:0] sum;               // Declare sum as a 3-bit wide wire
    
    assign sum = A1_N + A2_N + B1 + B2;  // Create the sum
    assign Y = sum[1:0];          // Assign the lower 2 bits to Y
    assign overflow_flag = sum[2]; // Assign the overflow bit

endmodule