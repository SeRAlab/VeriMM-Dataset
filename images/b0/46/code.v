module top_module(clk, readAdd0, readAdd1, writeAdd, regWR, writeData, readOutput0, readOutput1);parameter NUM_REGISTERS = 16;
    parameter DATA_WIDTH = 32;

    input clk, regWR;
    input [4:0] readAdd0, readAdd1, writeAdd;
    input [DATA_WIDTH-1:0] writeData;
    output [DATA_WIDTH-1:0] readOutput0, readOutput1;

    reg [DATA_WIDTH-1:0] registers [0:NUM_REGISTERS-1];

    always @(posedge clk) begin
        if (regWR == 0) begin
            registers[writeAdd] <= writeData;
        end
    end

    assign readOutput0 = registers[readAdd0];
    assign readOutput1 = registers[readAdd1];
endmodule