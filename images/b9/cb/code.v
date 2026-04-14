module top_module(
    input clk_a,
    input clk_b,
    input en_a,
    input en_b,
    input [3:0] addr_a,
    input [3:0] addr_b,
    input [3:0] data_a,
    input [3:0] data_b,
    input we_a,
    input we_b,
    output reg [3:0] data_out_a,
    output reg [3:0] data_out_b
);reg [3:0] mem_a [0:3];
    reg [3:0] mem_b [0:3];

    always @(posedge clk_a) begin
        if (en_a) begin
            if (we_a) begin
                mem_a[addr_a] <= data_a;
            end
            data_out_a <= mem_a[addr_a];
        end
    end

    always @(posedge clk_b) begin
        if (en_b) begin
            if (we_b) begin
                mem_b[addr_b] <= data_b;
            end
            data_out_b <= mem_b[addr_b];
        end
    end

endmodule