module quarter_round(  
    input clk,  
    input rst,  
    input [31:0] x0, x1, x2, x3,  
    output reg [31:0] y0, y1, y2, y3  
);  

reg [31:0] a, b, c, d;  

always @(posedge clk or posedge rst) begin  
    if (rst) begin  
        y0 <= 32'b0;  
        y1 <= 32'b0;  
        y2 <= 32'b0;  
        y3 <= 32'b0;  
    end else begin  
        a <= x0;  
        b <= x1;  
        c <= x2;  
        d <= x3;  

        // Quarter round operations  
        a <= a + b;  
        d <= d ^ a;  
        d <= {d[15:0], d[31:16]};  

        c <= c + d;  
        b <= b ^ c;  
        b <= {b[23:0], b[31:24]};  

        a <= a + b;  
        d <= d ^ a;  
        d <= {d[15:0], d[31:16]};  

        c <= c + d;  
        b <= b ^ c;  
        b <= {b[23:0], b[31:24]};  

        // Assign output  
        y0 <= a;  
        y1 <= b;  
        y2 <= c;  
        y3 <= d;  
    end  
end  
endmodule