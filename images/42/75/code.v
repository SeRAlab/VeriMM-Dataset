module top_module(
    // Input
    input Clk,
    input Reset,
    input [31:0] PCIn,
    input [31:0] DataIn1,
    input [31:0] DataIn2,
    input [4:0] rsIn,
    input [31:0] ImmediateIn,
    input [4:0] rtIn,
    input [2:0] WBIn,
    input [1:0] MIn,
    input [4:0] EXIn,

    // Output
    output reg [31:0] PCOut,
    output reg [31:0] DataOut1,
    output reg [31:0] DataOut2,
    output reg [4:0] rsOut,
    output reg [31:0] ImmediateOut,
    output reg [4:0] rtOut,
    output reg [2:0] WBOut,
    output reg [1:0] MOut,
    output reg [4:0] EXOut
);always @(posedge Clk or posedge Reset) begin
        if (Reset) begin
            PCOut <= 32'b0;
            DataOut1 <= 32'b0;
            DataOut2 <= 32'b0;
            rsOut <= 5'b0;
            ImmediateOut <= 32'b0;
            rtOut <= 5'b0;
            WBOut <= 3'b0;
            MOut <= 2'b0;
            EXOut <= 4'b0;
        end else begin
            PCOut <= PCIn;
            DataOut1 <= DataIn1;
            DataOut2 <= DataIn2;
            rsOut <= rsIn;
            ImmediateOut <= ImmediateIn;
            rtOut <= rtIn;
            WBOut <= WBIn;
            MOut <= MIn;
            EXOut <= EXIn;
        end
    end

endmodule