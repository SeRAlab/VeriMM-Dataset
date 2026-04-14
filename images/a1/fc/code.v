module reg_file_16bit(clk, reset, write_enable, write_addr, write_data, read_addr, read_data);
    input clk;
    input reset;
    input write_enable;
    input [1:0] write_addr;
    input [15:0] write_data;
    input [1:0] read_addr;
    output reg [15:0] read_data;

    reg [15:0] registers [3:0];

    always @(posedge clk) begin
        if (reset) begin
            registers[0] <= 16'b0;
            registers[1] <= 16'b0;
            registers[2] <= 16'b0;
            registers[3] <= 16'b0;
        end
        else if (write_enable) begin
            registers[write_addr] <= write_data;
        end
    end

    always @(*) begin
        read_data = registers[read_addr];
    end
endmodule