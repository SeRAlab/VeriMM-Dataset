module sync_ram (
    input clk,
    input [7:0] addr,
    input [7:0] data_in,
    input we,
    output reg [7:0] data_out
);

    reg [7:0] ram [0:15];

    always @(posedge clk) begin
        if (we) begin
            ram[addr] <= data_in;
        end else begin
            data_out <= ram[addr];
        end
    end

endmodule