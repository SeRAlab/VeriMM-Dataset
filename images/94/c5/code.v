module reg_file(
    input                 clk,
    input                 rst,
    input                 we,
    input       [1:0]     waddr,
    input       [7:0]     wdata,
    input       [1:0]     raddr1,
    input       [1:0]     raddr2,
    output   reg [7:0]    rdata1,
    output   reg [7:0]    rdata2
);

reg [7:0] registers [0:3];  // 4 registers of 8 bits each

// Write logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        registers[0] <= 8'd0;
        registers[1] <= 8'd0;
        registers[2] <= 8'd0;
        registers[3] <= 8'd0;
    end else if (we) begin
        registers[waddr] <= wdata;
    end
end

// Read logic
always @(*) begin
    rdata1 = registers[raddr1];
    rdata2 = registers[raddr2];
end

endmodule