module regfile_16bit(
    input clk,
    input we,
    input [2:0] read_addr1, read_addr2, write_addr,
    input [15:0] write_data,
    output [15:0] read_data1, read_data2
);
    reg [15:0] regs [7:0];

    always @(posedge clk) begin
        if (we)
            regs[write_addr] <= write_data;
    end

    assign read_data1 = regs[read_addr1];
    assign read_data2 = regs[read_addr2];
endmodule