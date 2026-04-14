module top_module(
    input CLK,
    input wire [31:0] DAddr,  
    input wire [31:0] DataIn,
    input RD,             
    input WR,              
    
    output wire [31:0] DataOut
);reg [7:0] Memory [0:127];
wire [31:0] address;


assign address = (DAddr << 2);



assign DataOut[7:0] = (RD == 0) ? Memory[address + 3] : 8'bz;
assign DataOut[15:8] = (RD == 0) ? Memory[address + 2] : 8'bz;
assign DataOut[23:16] = (RD == 0) ? Memory[address + 1] : 8'bz;
assign DataOut[31:24] = (RD == 0) ? Memory[address] : 8'bz;


always @ (negedge CLK) begin
    if(WR == 0) begin
        Memory[address] <= DataIn[31:24];
        Memory[address + 1] <= DataIn[23:16];
        Memory[address + 2] <= DataIn[15:8];
        Memory[address + 3] <= DataIn[7:0];
    end
end
 
endmodule