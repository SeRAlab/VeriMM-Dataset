module reg_file_16x8 (
    input clk,
    input reset,
    input write_enable,
    input [15:0] write_data,
    input [2:0] write_address,
    input [2:0] read_address1,
    input [2:0] read_address2,
    output [15:0] read_data1,
    output [15:0] read_data2
);

reg [15:0] registers [7:0];

assign read_data1 = registers[read_address1];
assign read_data2 = registers[read_address2];

always @(posedge clk or posedge reset) begin
    if (reset) 
    begin
        registers[0] <= 16'b0;
        registers[1] <= 16'b0;
        registers[2] <= 16'b0;
        registers[3] <= 16'b0;
        registers[4] <= 16'b0;
        registers[5] <= 16'b0;
        registers[6] <= 16'b0;
        registers[7] <= 16'b0;
    end 
    else if (write_enable) 
    begin
        registers[write_address] <= write_data;
    end
end

endmodule