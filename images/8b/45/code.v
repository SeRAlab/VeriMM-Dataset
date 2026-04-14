module top_module(
    A,
    B,
    SUM,
    OVF
);input [1:0] A;
    input [1:0] B;
    output [1:0] SUM;
    output OVF;
    
    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    wire [2:0] temp_sum;
    
    // 2-bit adder
    assign temp_sum = {1'b0, A} + {1'b0, B};
    
    // Overflow detection
    assign OVF = (temp_sum[2] == 1);
    
    // Output SUM
    assign SUM = temp_sum[1:0];

endmodule