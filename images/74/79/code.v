module register_file
    (
		input clk,
        input rst_n,
        input we,
        input [1:0] wr_addr,
        input [1:0] rd_addr1,
        input [1:0] rd_addr2,
        input [15:0] data_in,
        output reg [15:0] rd_data1,
        output reg [15:0] rd_data2
    );

reg [15:0] regs [0:3];

always @(posedge clk or negedge rst_n) 
    begin
        if (!rst_n)
            begin
                regs[0] <= 16'b0;
                regs[1] <= 16'b0;
                regs[2] <= 16'b0;
                regs[3] <= 16'b0;
            end
        else if (we)
            regs[wr_addr] <= data_in;
    end

always @(posedge clk or negedge rst_n) 
    begin
        if (!rst_n)
            begin
                rd_data1 <= 16'b0;
                rd_data2 <= 16'b0;
            end
        else
            begin
                rd_data1 <= regs[rd_addr1];
                rd_data2 <= regs[rd_addr2];
            end
    end

endmodule