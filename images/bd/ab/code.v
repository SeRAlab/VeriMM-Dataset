module regfile_32bit_8reg (read_data1, read_data2, clk, reset, read_addr1, read_addr2, write_addr, write_en, write_data);
   input clk, reset;
   input [2:0] read_addr1, read_addr2, write_addr;
   input write_en;
   input [31:0] write_data;
   output [31:0] read_data1, read_data2;
   
   reg [31:0] registers [7:0];
   reg [31:0] read_data1, read_data2;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        registers[0] <= 32'b0;
        registers[1] <= 32'b0;
        registers[2] <= 32'b0;
        registers[3] <= 32'b0;
        registers[4] <= 32'b0;
        registers[5] <= 32'b0;
        registers[6] <= 32'b0;
        registers[7] <= 32'b0;
    end 
    else if (write_en) 
        registers[write_addr] <= write_data;
end

always @(*) begin
    read_data1 = registers[read_addr1];
    read_data2 = registers[read_addr2];
end

endmodule