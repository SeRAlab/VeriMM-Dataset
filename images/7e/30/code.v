module top_module(
    input [3:0] A, B,
    input Cin,
    output reg [3:0] S,  // Changed to output reg
    output reg Cout      // Changed to output reg
);reg [4:0] temp_sum;
    
    always @(*) begin
        temp_sum = A + B + Cin;
        S = temp_sum[3:0];
        Cout = temp_sum[4];
    end
    
endmodule