module top_module(
    input clk,
    input rst_n,
    input [8:0] addr_in,
    output reg [15:0] data_out,
    output reg [8:0] addr_out
);reg [15:0] mem [511:0]; // ROM memory

    // Initialize memory with random data
    integer i;
    initial begin
        for (i = 0; i < 512; i = i + 1) begin
            mem[i] = $random;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            data_out <= 16'h0;
            addr_out <= 9'h0;
        end
        else begin
            data_out <= mem[addr_in];
            addr_out <= addr_in;
        end
    end

endmodule