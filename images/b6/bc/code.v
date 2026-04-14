module reg_file (
    input clk,
    input rst,
    input write_en,
    input [2:0] write_addr,
    input [15:0] write_data,
    input [2:0] read_addr,
    output reg [15:0] read_data
);

    reg [15:0] regs [7:0];

    always @(posedge clk) begin
        if (rst) begin
            regs[0] <= 16'd0;
            regs[1] <= 16'd0;
            regs[2] <= 16'd0;
            regs[3] <= 16'd0;
            regs[4] <= 16'd0;
            regs[5] <= 16'd0;
            regs[6] <= 16'd0;
            regs[7] <= 16'd0;
        end else if (write_en) begin
            regs[write_addr] <= write_data;
        end
    end

    always @(*) begin
        read_data = regs[read_addr];
    end

endmodule