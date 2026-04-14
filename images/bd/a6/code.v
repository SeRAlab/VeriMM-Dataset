module top_module(
    input [7:0] A, 
    input [7:0] B, 
    output reg [15:0] Z, 
    output reg [7:0] SSEG_CA, 
    output reg [3:0] SSEG_AN, 
    input btnU, 
    input btnL,
    input btnR,
    input btnD
    );always @ (*) 
begin 
    if (btnU == 1)
        Z = A * B;
    else if (btnL == 1)
        Z = A / B;
    else if (btnR == 1)
        Z = A + B;
    else if (btnD == 1)
        Z = A - B;
    else
        Z = 0;
end 
    
always @ (*) begin
    SSEG_AN[0] = 0; 
    case (Z[3:0]) 
    0 : SSEG_CA = 8'b01000000; 
    1 : SSEG_CA = 8'b01111001;
    2 : SSEG_CA = 8'b00100100;
    3 : SSEG_CA = 8'b00110000;
    4 : SSEG_CA = 8'b00011001;
    5 : SSEG_CA = 8'b00010010;
    6 : SSEG_CA = 8'b00000010;
    7 : SSEG_CA = 8'b01111000;
    8 : SSEG_CA = 8'b00000000;
    9 : SSEG_CA = 8'b00010000;
    
    default : SSEG_CA = 8'b01000000;   
    endcase   
end

endmodule