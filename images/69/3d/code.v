module memory_4x4 (
        input [1:0] addr,
        input [3:0] data_in,
        input we,
        input clk,
        output reg [3:0] data_out);

    reg [3:0] mem [3:0];

    always @(posedge clk) begin
        if (we)
            mem[addr] <= data_in;
        data_out <= mem[addr];
    end

endmodule