module top_module(
    input              iCLK,    
    input      [7:0]   iAddr,   
    input      [15:0]  iData,   
    input              iWen,    
    output reg [15:0]  oData    
);reg [15:0] RAM [255:0];
    
    always @(posedge iCLK) begin
        oData <= RAM[iAddr];
        if(iWen) begin
            RAM[iAddr] <= iData;
        end
    end
    
endmodule