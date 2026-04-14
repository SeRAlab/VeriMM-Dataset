module top_module(
    input clock,
    input reset,
    input [63:0] address,
    output reg [79:0] readData
    );reg [7:0] memFile [0:127];  
    always @ (address)
    begin
        readData={memFile[address+9],memFile[address+8],memFile[address+7],memFile[address+6],memFile[address+5],memFile[address+4],memFile[address+3],memFile[address+2],memFile[address+1],memFile[address]};
    end
    
endmodule