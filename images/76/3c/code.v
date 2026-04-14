module top_module(
    input clk,
    input write_en,
    input [2:0] write_reg,
    input [31:0] write_data,
    input read_en,
    input [2:0] read_reg1,
    input [2:0] read_reg2,
    output reg [31:0] read_data1,
    output reg [31:0] read_data2
);reg [31:0] registers [0:7];

    always @ (posedge clk) begin
        if (write_en) begin
            registers[write_reg] <= write_data;
        end
        if (read_en) begin
            read_data1 <= registers[read_reg1];
            read_data2 <= registers[read_reg2];
        end
    end

endmodule