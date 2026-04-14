module top_module (
    input clk,
    input [3:0] write_addr,
    input [3:0] read_addr,
    input [7:0] write_data,
    input we_n,
    output reg [7:0] read_data
);

    reg [7:0] mem [15:0]; // 16-word deep memory

    always @(posedge clk) begin
        if (!we_n)
            mem[write_addr] <= write_data; // Write data to memory
        read_data <= mem[read_addr]; // Read data from memory
    end

endmodule