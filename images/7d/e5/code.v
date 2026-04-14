module register_file_8bit_4reg(
    input clk,
    input we,
    input [1:0] write_addr,
    input [1:0] read_addr,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] registers [3:0];
    
    always @(posedge clk) begin
        if (we)
            registers[write_addr] <= data_in;
    end
    
    always @(*) begin
        data_out = registers[read_addr];
    end
endmodule