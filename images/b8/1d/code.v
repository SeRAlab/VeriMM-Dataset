module register_file(
    input clk,
    input we,
    input [2:0] write_addr,
    input [7:0] write_data,
    input [2:0] read_addr1,
    input [2:0] read_addr2,
    output reg [7:0] read_data1,
    output reg [7:0] read_data2
);

    // Register array
    reg [7:0] registers [7:0];

    // Always block triggered on the rising edge of the clock for writing
    always @(posedge clk) begin
        if (we) begin
            registers[write_addr] <= write_data;
        end
    end

    // Continuous assignment for reading
    always @(*) begin
        read_data1 = registers[read_addr1];
        read_data2 = registers[read_addr2];
    end

endmodule