module top_module(clk, nRD, nWR, DAddr, DataIn, DataOut);input clk, nRD, nWR;
    input [31:0] DAddr, DataIn;
    output [31:0] DataOut;
    
    reg [7:0] ram [0:60];
    assign DataOut[7:0] = (nRD==1)?ram[DAddr + 3]:8'bz; 
    assign DataOut[15:8] = (nRD==1)?ram[DAddr + 2]:8'bz;
    assign DataOut[23:16] = (nRD==1)?ram[DAddr + 1]:8'bz;
    assign DataOut[31:24] = (nRD==1)?ram[DAddr ]:8'bz;

    always@( negedge clk ) 
    begin 
        if( nWR==1 ) 
        begin
            ram[DAddr] <= DataIn[31:24];
            ram[DAddr+1] <= DataIn[23:16];
            ram[DAddr+2] <= DataIn[15:8];
            ram[DAddr+3] <= DataIn[7:0];
        end
    end
endmodule