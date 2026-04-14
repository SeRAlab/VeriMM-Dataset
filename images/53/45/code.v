module top_module(
    input wire rom_oe_n,
    input wire ram_oe_n,
    input wire asic_oe_n,
    input wire [7:0] data_from_rom,
    input wire [7:0] data_from_ram,
    input wire [7:0] data_from_asic,
    input wire [15:0] cpuaddr,
    output reg [7:0] data_to_cpu
);always @(*) begin
    if (rom_oe_n == 1'b0) begin
        data_to_cpu = data_from_rom;
    end else if (ram_oe_n == 1'b0) begin
        data_to_cpu = data_from_ram;
    end else if (asic_oe_n == 1'b0) begin
        data_to_cpu = data_from_asic;
    end else begin
        data_to_cpu = 8'hFF;
    end
end

endmodule