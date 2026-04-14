module reg_file(
    input clk,
    input [2:0] read_addr1,
    input [2:0] read_addr2,
    input [2:0] write_addr,
    input [15:0] write_data,
    input write_en,
    output [15:0] read_data1,
    output [15:0] read_data2
    );

    reg [15:0] registers [7:0];

    always @(posedge clk) begin
        if (write_en) begin
            registers[write_addr] <= write_data;
        end
    end

    assign read_data1 = registers[read_addr1];
    assign read_data2 = registers[read_addr2];
endmodule