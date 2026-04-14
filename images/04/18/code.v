module register_file (
    input wire [3:0] addr,
    input wire [31:0] wdata,
    input wire we,
    input wire clk,
    output reg [31:0] rdata
);
    reg [31:0] registers [15:0]; // 16 registers of 32 bits each

    always @(posedge clk) begin
        if (we) begin
            registers[addr] <= wdata; // Write data to register if write enable is high
        end
    end

    always @(*) begin
        rdata = registers[addr]; // Read data from the specified register
    end
endmodule