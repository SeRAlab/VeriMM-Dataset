module top_module(
    input [31:0]iData,
    input [2:0]sel,
    
    output [31:0]oData
    );assign oData=~sel[2]&~sel[1]&~sel[0]?iData:32'bz;
    assign oData=~sel[2]&~sel[1]&sel[0]?{16'b0,iData[15:0]}:32'bz;
    assign oData=~sel[2]&sel[1]&~sel[0]?{(iData[15]?16'hffff:16'b0),iData[15:0]}:32'bz;
    assign oData=~sel[2]&sel[1]&sel[0]?{iData[15]?14'h3fff:14'b0,iData[15:0],2'b0}:32'bz;
endmodule