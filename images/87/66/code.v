module top_module(clk, rst, read_addr, write_addr, write_data, read_data);parameter WIDTH = 64;
parameter SIZE = 1024;
parameter LATENCY = 10;

// Define the address width based on SIZE
localparam ADDR_WIDTH = $clog2(SIZE);

input clk, rst;
input [ADDR_WIDTH-1:0] read_addr, write_addr; // Use calculated address width
input [WIDTH-1:0] write_data;
output reg [WIDTH-1:0] read_data;

reg [WIDTH-1:0] mem [0:SIZE-1];
reg [ADDR_WIDTH-1:0] read_addr_reg, write_addr_reg; // Use calculated address width
reg [WIDTH-1:0] write_data_reg;
reg [LATENCY-1:0] write_latency, read_latency;

integer i; // Declare the loop index variable i

always @(posedge clk) begin
    if (rst) begin
        for (i = 0; i < SIZE; i = i + 1) begin
            mem[i] <= 0;
        end
        read_data <= 0;
        read_addr_reg <= 0;
        write_addr_reg <= 0;
        write_data_reg <= 0;
        write_latency <= 0;
        read_latency <= 0;
    end else begin
        // Write operation
        if (write_latency > 0) begin
            write_latency <= write_latency - 1;
        end else if (write_addr_reg != write_addr) begin
            write_addr_reg <= write_addr;
            write_data_reg <= write_data;
            write_latency <= LATENCY - 1;
            mem[write_addr] <= write_data;
        end else if (write_addr_reg == write_addr) begin
            write_latency <= LATENCY - 1;
            mem[write_addr] <= write_data_reg;
        end

        // Read operation
        if (read_latency > 0) begin
            read_latency <= read_latency - 1;
        end else if (read_addr_reg != read_addr) begin
            read_addr_reg <= read_addr;
            read_latency <= LATENCY - 1;
            read_data <= mem[read_addr];
        end else if (read_addr_reg == read_addr) begin
            read_latency <= LATENCY - 1;
            read_data <= mem[read_addr_reg];
        end
    end
end

endmodule