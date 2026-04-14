module top_module(
    input [31:0] instruction,
    output reg [5:0] fld_opcode,
    output reg [1:0] fld_affect,
    output reg [4:0] fld_field0,
    output reg [4:0] fld_field1,
    output reg [4:0] fld_field2,
    output reg [1:0] fld_shift_type,
    output reg fld_shift_IR,
    output reg [4:0] fld_shamt_S,
    output reg [4:0] fld_shamt_I,
    output reg [4:0] fld_shamt_R,
    output reg [15:0] fld_immediate
);always @(*) begin
        fld_opcode = instruction[31:26];
        fld_affect = instruction[25:24];
        fld_field0 = instruction[23:19];
        fld_field1 = instruction[18:14];
        fld_field2 = instruction[13:9];
        fld_shift_type = instruction[8:7];
        fld_shift_IR = instruction[6];
        fld_shamt_S = instruction[4:0];
        fld_shamt_I = instruction[4:0];
        fld_shamt_R = instruction[4:0];
        fld_immediate = instruction[15:0];
    end

endmodule