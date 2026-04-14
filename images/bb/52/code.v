module top_module(
    input CLK_I,
    input RST_I,
    input [31:0] DAT_I,
    input ACK_I,
    input INT_I,
    output reg [31:0] ADR_O,
    output reg [31:0] DAT_O,
    output reg WE_O,
    output reg [3:0] SEL_O,
    output reg STB_O,
    output reg CYC_O
);reg [31:0] mem_address_reg;
    reg [31:0] mem_data_w_reg;
    reg [31:0] mem_data_r_reg;
    reg [3:0] mem_byte_sel_reg;
    reg mem_write_reg;
    reg mem_pause_reg;

    // Instead of using wires for STB_O and CYC_O, they must be declared as reg.
    always @(posedge CLK_I) begin
        if (RST_I) begin
            mem_address_reg <= 0;
            mem_data_w_reg <= 0;
            mem_data_r_reg <= 0;
            mem_byte_sel_reg <= 0;
            mem_write_reg <= 0;
            mem_pause_reg <= 1;
            STB_O <= 1;
            CYC_O <= 1;
        end else begin
            mem_address_reg <= ADR_O;
            mem_data_w_reg <= DAT_O;
            mem_byte_sel_reg <= SEL_O;
            mem_write_reg <= WE_O;
            mem_pause_reg <= ~ACK_I;
            DAT_O <= DAT_I;
            STB_O <= ~RST_I; // Update STB_O in a procedural block
            CYC_O <= ~RST_I; // Update CYC_O in a procedural block
        end
    end

endmodule