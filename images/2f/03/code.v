module quarter_round (  
    input clk,  
    input rst,  
    input [31:0] a,  
    input [31:0] b,  
    input [31:0] c,  
    input [31:0] d,  
    output reg [31:0] out_a,  
    output reg [31:0] out_b,  
    output reg [31:0] out_c,  
    output reg [31:0] out_d  
);  
    wire [31:0] sum1, sum2, sum3, sum4;  
    wire [31:0] rot1, rot2, rot3, rot4;  

    assign sum1 = a + b;  
    assign rot1 = {sum1[15:0], sum1[31:16]};  
    assign sum2 = rot1 + c;  
    assign rot2 = {sum2[11:0], sum2[31:12]};  
    assign sum3 = rot2 + d;  
    assign rot3 = {sum3[7:0], sum3[31:8]};  
    assign sum4 = rot3 + a;  
    assign rot4 = {sum4[6:0], sum4[31:7]};  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            out_a <= 0;  
            out_b <= 0;  
            out_c <= 0;  
            out_d <= 0;  
        end else begin  
            out_a <= rot4;  
            out_b <= rot1;  
            out_c <= rot2;  
            out_d <= rot3;  
        end  
    end  
endmodule