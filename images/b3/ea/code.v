module top_module(
    input [7:0] Input_Data,
    output reg[7:0] Output_Data
    );always@(*)
    begin
        Output_Data <= Input_Data;
    end
endmodule