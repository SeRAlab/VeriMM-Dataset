module chacha20_quarter_round (  
    input clk,  
    input rst,  
    input [31:0] in_a,  
    input [31:0] in_b,  
    input [31:0] in_c,  
    input [31:0] in_d,  
    output reg [31:0] out_a,  
    output reg [31:0] out_b,  
    output reg [31:0] out_c,  
    output reg [31:0] out_d  
);  

    reg [31:0] a, b, c, d;  
    wire [31:0] rot_d, rot_b;  

    assign rot_d = {d[15:0], d[31:16]};  
    assign rot_b = {b[19:0], b[31:20]};  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            out_a <= 32'b0;  
            out_b <= 32'b0;  
            out_c <= 32'b0;  
            out_d <= 32'b0;  
        end else begin  
            a <= in_a;  
            b <= in_b;  
            c <= in_c;  
            d <= in_d;  

            a <= a + b;  
            d <= d ^ a;  
            d <= rot_d;  

            c <= c + d;  
            b <= b ^ c;  
            b <= rot_b;  

            a <= a + b;  
            d <= d ^ a;  
            d <= {d[7:0], d[31:8]};  

            c <= c + d;  
            b <= b ^ c;  
            b <= {b[11:0], b[31:12]};  

            out_a <= a;  
            out_b <= b;  
            out_c <= c;  
            out_d <= d;  
        end  
    end  
endmodule