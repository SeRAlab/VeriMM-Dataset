module reg_file (
    input clk,
    input reset,
    input wr_en,
    input [1:0] wr_addr,
    input [1:0] rd_addr,
    input [15:0] wr_data,
    output [15:0] rd_data
);

    reg [15:0] regs [0:3];  // 4 registers, each 16-bit

    always @(posedge clk) begin
        if (reset) begin
            regs[0] <= 16'b0;
            regs[1] <= 16'b0;
            regs[2] <= 16'b0;
            regs[3] <= 16'b0;
        end else if (wr_en) begin
            regs[wr_addr] <= wr_data;  // Write to the specified register
        end
    end

    assign rd_data = regs[rd_addr];  // Read from the specified register

endmodule