module md5_simple (  
    input clk,  
    input reset,  
    input [63:0] data_in,  
    output reg [31:0] hash_out  
);  

reg [31:0] A, B, C, D;  
reg [63:0] data;  

always @(posedge clk or posedge reset) begin  
    if (reset) begin  
        A <= 32'h67452301;  
        B <= 32'hEFCDAB89;  
        C <= 32'h98BADCFE;  
        D <= 32'h10325476;  
        hash_out <= 32'h0;  
    end else begin  
        data <= data_in;  
        // Simplified transformation  
        A <= A + ((B & C) | (~B & D)) + data[31:0] + 32'hD76AA478;  
        B <= B + ((A & D) | (~A & C)) + data[63:32] + 32'hE8C7B756;  
        C <= C + ((B & A) | (~B & D)) + data[31:0] + 32'h242070DB;  
        D <= D + ((C & B) | (~C & A)) + data[63:32] + 32'hC1BDCEEE;  
        hash_out <= A + B + C + D;  
    end  
end  
endmodule