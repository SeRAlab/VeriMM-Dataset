module monte_carlo_pi (  
    input [31:0] x0, y0,  
    input [31:0] x1, y1,  
    input [31:0] x2, y2,  
    input [31:0] x3, y3,  
    input [31:0] x4, y4,  
    output reg [2:0] inside_count  
);  
    always @(*) begin  
        inside_count = 0;  
        if ((x0 * x0 + y0 * y0) <= 32'h00000001) inside_count = inside_count + 1;  
        if ((x1 * x1 + y1 * y1) <= 32'h00000001) inside_count = inside_count + 1;  
        if ((x2 * x2 + y2 * y2) <= 32'h00000001) inside_count = inside_count + 1;  
        if ((x3 * x3 + y3 * y3) <= 32'h00000001) inside_count = inside_count + 1;  
        if ((x4 * x4 + y4 * y4) <= 32'h00000001) inside_count = inside_count + 1;  
    end  
endmodule