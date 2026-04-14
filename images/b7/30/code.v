module reg_file_8bit (
    input clk,
    input rst,
    input we,
    input [2:0] write_addr,
    input [7:0] write_data,
    input [2:0] read_addr,
    output reg [7:0] read_data
);

reg [7:0] regfile [7:0];

always @(posedge clk or posedge rst) begin
    if (rst) begin
        regfile[0] <= 8'b0;
        regfile[1] <= 8'b0;
        regfile[2] <= 8'b0;
        regfile[3] <= 8'b0;
        regfile[4] <= 8'b0;
        regfile[5] <= 8'b0;
        regfile[6] <= 8'b0;
        regfile[7] <= 8'b0;
    end else if (we) begin
        regfile[write_addr] <= write_data;
    end
end

always @(*) begin
    read_data = regfile[read_addr];
end

endmodule