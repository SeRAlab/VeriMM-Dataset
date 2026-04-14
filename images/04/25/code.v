module nearest_neighbor_interpolation (
    input [7:0] A, 
    input [7:0] B, 
    input [7:0] C, 
    input [7:0] D,
    output reg [7:0] out1, 
    output reg [7:0] out2, 
    output reg [7:0] out3, 
    output reg [7:0] out4,
    output reg [7:0] out5, 
    output reg [7:0] out6, 
    output reg [7:0] out7, 
    output reg [7:0] out8
);
    
    always @(*) begin
        out1 = A; out2 = A; out3 = B; out4 = B;
        out5 = A; out6 = A; out7 = B; out8 = B;
        out1 = C; out2 = C; out3 = D; out4 = D;
        out5 = C; out6 = C; out7 = D; out8 = D;
    end
endmodule