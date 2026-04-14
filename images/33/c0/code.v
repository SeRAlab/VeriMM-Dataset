module quarter_round (  
    input  wire [31:0] a,  
    input  wire [31:0] b,  
    input  wire [31:0] c,  
    input  wire [31:0] d,  
    output reg  [31:0] out_a,  
    output reg  [31:0] out_b,  
    output reg  [31:0] out_c,  
    output reg  [31:0] out_d,  
    input  wire clk,  
    input  wire rst  
);  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        out_a <= 32'b0;  
        out_b <= 32'b0;  
        out_c <= 32'b0;  
        out_d <= 32'b0;  
    end else begin  
        out_a <= a + b;  
        out_b <= b ^ out_a;  
        out_b <= {out_b[23:0], out_b[31:24]} + c;  
        out_c <= c ^ out_b;  
        out_c <= {out_c[22:0], out_c[31:23]} + d;  
        out_d <= d ^ out_c;  
        out_d <= {out_d[17:0], out_d[31:18]} + out_a;  
    end  
end  
endmodule