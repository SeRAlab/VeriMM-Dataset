module register_file(
    input clk,
    input [2:0] read_reg1,
    input [2:0] read_reg2,
    input [2:0] write_reg,
    input [15:0] write_data,
    input write_enable,
    output reg [15:0] read_data1,
    output reg [15:0] read_data2
);
    reg [15:0] registers [7:0];

    always @(posedge clk) begin
        if (write_enable)
            registers[write_reg] <= write_data;
    end

    always @(*) begin
        read_data1 = registers[read_reg1];
        read_data2 = registers[read_reg2];
    end
endmodule