module top_module(
    input wire [4:0] a,  
    input wire [3:0] b,  
    output wire [4:0] o  
    );wire [6:0] res1 = ((b[0] == 1'b1)? a : 5'h00)         + ((b[1] == 1'b1)? {a,1'b0} : 6'h00);  
    wire [8:0] res2 = ((b[2] == 1'b1)? {a,2'b00} : 7'h00) + ((b[3] == 1'b1)? {a,3'b000} : 8'h00);
    wire [8:0] res3 = res1 + res2;
    assign o = res3[8:4];
endmodule