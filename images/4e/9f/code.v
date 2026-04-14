module sync_ram_8bit (
    input clk,
    input [7:0] addr,
    input [7:0] data_in,
    input we,
    output reg [7:0] data_out
);

    reg [7:0] memory [255:0];

    always @(posedge clk) begin
        if (we)
            memory[addr] <= data_in;
        data_out <= memory[addr];
    end

endmodule