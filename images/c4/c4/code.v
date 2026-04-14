module adder_16bit(
    input [15:0] A, B,
    output [15:0] S,
    output C
    );

    wire [15:0] temp;
    wire [16:0] sum;
    
    assign temp = A ^ B;
    assign sum = {1'b0, A} + {1'b0, B};
    assign S = sum[15:0];
    assign C = sum[16];

endmodule