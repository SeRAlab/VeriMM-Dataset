module top_module(
    input           rst,
    input           clk,

    input           DataInEnable,
    input           DataInColor,
    input [5:0]     DataInCount,
    input [7:0]     DataIn,

    input           TableColor,
    input  [5:0]    TableNumber,
    output [7:0]    TableData
);reg [7:0]       DQT_Y [0:63];
    reg [7:0]       DQT_C [0:63];

    
    always @(posedge clk) begin
        if(DataInEnable ==1'b1 && DataInColor ==1'b0) begin
            DQT_Y[DataInCount] <= DataIn;
        end
        if(DataInEnable ==1'b1 && DataInColor ==1'b1) begin
            DQT_C[DataInCount] <= DataIn;
        end
    end

    reg [7:0] TableDataY;
    reg [7:0] TableDataC;

    
    always @(posedge clk) begin
        TableDataY <= DQT_Y[TableNumber];
        TableDataC <= DQT_C[TableNumber];
    end

    
    assign TableData = (TableColor)?TableDataC:TableDataY;
endmodule