module top_module(
    input clock,
    input [15:0] data_a,
    input [15:0] data_b,
    input [3:0] address_a,
    input [3:0] address_b,
    input write_enable_a,
    input write_enable_b,
    output reg [15:0] q_a,
    output reg [15:0] q_b
);reg [15:0] ram [0:15];

    always @(posedge clock) begin
        if (write_enable_a) begin
            ram[address_a] <= data_a;
        end
        if (write_enable_b) begin
            ram[address_b + 16] <= data_b;
        end
        q_a <= ram[address_a];
        q_b <= ram[address_b + 16];
    end

endmodule