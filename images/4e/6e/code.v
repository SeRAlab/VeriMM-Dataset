module memory(
    input clk,
    input we,
    input [2:0] addr,
    input [15:0] data_in,
    output reg [15:0] data_out
);

    reg [15:0] mem [7:0]; // 8-word deep, 16-bit wide memory

    always @(posedge clk) begin
        if (we)
            mem[addr] <= data_in; // Write operation
        data_out <= mem[addr]; // Read operation
    end

endmodule