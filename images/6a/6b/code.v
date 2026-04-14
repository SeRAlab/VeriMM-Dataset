module RegisterFile (
    input clk,
    input rst_n,
    input write_enable,
    input [1:0] write_address,
    input [1:0] read_address,
    input [15:0] write_data,
    output reg [15:0] read_data
);
    reg [15:0] registers [0:3];
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            registers[0] <= 16'b0;
            registers[1] <= 16'b0;
            registers[2] <= 16'b0;
            registers[3] <= 16'b0;
        end else if (write_enable) begin
            registers[write_address] <= write_data;
        end
    end
    
    always @(*) begin
        read_data = registers[read_address];
    end
endmodule