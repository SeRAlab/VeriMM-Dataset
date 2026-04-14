module top_module(
    input clk,
    input reset,
    input [1:0] rd_addr1,
    input [1:0] rd_addr2,
    input [1:0] wr_addr,
    input [15:0] wr_data,
    output [15:0] rd_data1,
    output [15:0] rd_data2
);

    reg [15:0] regfile [3:0];

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            regfile[0] <= 16'b0;
            regfile[1] <= 16'b0;
            regfile[2] <= 16'b0;
            regfile[3] <= 16'b0;
        end else begin
            regfile[wr_addr] <= wr_data;
        end
    end

    assign rd_data1 = regfile[rd_addr1];
    assign rd_data2 = regfile[rd_addr2];

endmodule