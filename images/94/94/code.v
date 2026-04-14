module top_module(
    // ----- Inputs -------
    DataA,
    DataB,
    Cin,
    Add_Sub,
    // ----- Outputs -------
    Result,
    Cout
    );/////////////////////////////////////////////////////
// Inputs
/////////////////////////////////////////////////////

input [31:0] DataA;
input [31:0] DataB;
input Cin;
input Add_Sub;

/////////////////////////////////////////////////////
// Outputs
/////////////////////////////////////////////////////

output [31:0] Result;
wire   [31:0] Result;
output Cout;
wire   Cout;

/////////////////////////////////////////////////////
// Instantiations
/////////////////////////////////////////////////////

wire [32:0] tmp_addResult = DataA + DataB + Cin;
wire [32:0] tmp_subResult = DataA - DataB - !Cin;

assign  Result = (Add_Sub == 1) ? tmp_addResult[31:0] : tmp_subResult[31:0];
assign  Cout = (Add_Sub == 1) ? tmp_addResult[32] : !tmp_subResult[32];

endmodule