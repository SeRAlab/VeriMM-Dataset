module comparator_64bit(
    input [63:0] a,
    input [63:0] b,
    output reg [1:0] result // 2'b00 for equal, 2'b01 for a > b, 2'b10 for a < b
);  
always @(*) begin  
    if (a > b)  
        result = 2'b01;  
    else if (a < b)  
        result = 2'b10;  
    else  
        result = 2'b00;  
end  
endmodule