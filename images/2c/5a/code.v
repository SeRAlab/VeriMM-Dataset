module nearest_neighbor_interpolation(  
    input [7:0] pixel00,  
    input [7:0] pixel01,  
    input [7:0] pixel10,  
    input [7:0] pixel11,  
    output reg [7:0] out00,  
    output reg [7:0] out01,  
    output reg [7:0] out10,  
    output reg [7:0] out11,  
    output reg [7:0] out20,  
    output reg [7:0] out21,  
    output reg [7:0] out30,  
    output reg [7:0] out31  
);  
  
always @(*) begin  
    out00 = pixel00;  
    out01 = pixel00;  
    out10 = pixel00;  
    out11 = pixel01;  
    out20 = pixel10;  
    out21 = pixel10;  
    out30 = pixel11;  
    out31 = pixel11;  
end  
endmodule