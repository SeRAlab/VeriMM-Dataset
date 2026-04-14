module top_module(
    input Clk,
    input RstN,
    input [3:0] Data_In,
    input Push,
    input Pop,
    output reg [3:0] Data_Out,
    output reg Full,
    output reg Empty
);reg [3:0] mem [7:0];
reg [3:0] a = 0;

always @(posedge Clk or negedge RstN) begin
    if (~RstN) begin
        a <= 0;
        Empty <= 1;
        Full <= 0;
    end 
    else if (Push & ~Full) begin
        if (a == 7) Full <= 1;
        mem[a] <= Data_In;
        a <= a + 1;
        Empty <= 0;
    end
    else if (Pop & ~Empty) begin
        if (a == 1) Empty <= 1;
        Data_Out <= mem[a-1];
        a <= a-1;
        Full <= 0;
    end
end

endmodule