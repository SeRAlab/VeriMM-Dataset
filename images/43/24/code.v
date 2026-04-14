module top_module(
    address_a,
    address_b,
    clock,
    q_a,
    q_b
);input [8:0] address_a;
input [8:0] address_b;
input clock;
output reg [31:0] q_a;
output reg [31:0] q_b;

reg [31:0] memory [0:63];

integer i;

initial begin
    // Initialize memory with random values
    for (i = 0; i < 64; i = i + 1) begin
        memory[i] = $random;
    end
end

always @(posedge clock) begin
    q_a = 0;
    q_b = 0;
    if (address_a < 64) begin
        if (memory[address_a] % 2 == 0) begin
            q_a = memory[address_a] ** 3;
        end
        else begin
            q_a = memory[address_a] ** 2;
        end
    end
    if (address_b < 64) begin
        if (memory[address_b] % 2 == 0) begin
            q_b = memory[address_b] ** 3;
        end
        else begin
            q_b = memory[address_b] ** 2;
        end
    end
end

endmodule