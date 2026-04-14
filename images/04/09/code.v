module register_file (
    input clk,
    input [1:0] read_addr_1,
    input [1:0] read_addr_2,
    input [1:0] write_addr,
    input [15:0] write_data,
    input write_enable,
    output reg [15:0] read_data_1,
    output reg [15:0] read_data_2
);
    reg [15:0] registers [3:0]; // 4 registers of 16 bits each

    always @(posedge clk) begin
        if (write_enable) begin
            registers[write_addr] <= write_data; // Write data to register
        end
    end

    always @(*) begin
        read_data_1 = registers[read_addr_1]; // Read data from register 1
        read_data_2 = registers[read_addr_2]; // Read data from register 2
    end
endmodule