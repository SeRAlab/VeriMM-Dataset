module dual_port_memory(
    input clk,
    input [4:0] read_addr1,
    input [4:0] read_addr2,
    input [4:0] write_addr1,
    input [4:0] write_addr2,
    input write_enable1,
    input write_enable2,
    input [31:0] write_data1,
    input [31:0] write_data2,
    output reg [31:0] read_data1,
    output reg [31:0] read_data2
    );

    reg [31:0] mem [0:31];

    always @(posedge clk) begin
        if (write_enable1)
            mem[write_addr1] <= write_data1;
        if (write_enable2)
            mem[write_addr2] <= write_data2;
    end

    always @(posedge clk) begin
        read_data1 <= mem[read_addr1];
        read_data2 <= mem[read_addr2];
    end
endmodule