module top_module(
    input clk,
    input ram_full_fb_i_reg,
    input tmp_ram_rd_en,
    input [11:0] Q,
    input [8:0] din,
    output reg [8:0] dout // Changed output to reg
);reg [8:0] ram[0:2047]; // Changed wire to reg for RAM

    // Write operation
    always @(posedge clk) begin
        if (!ram_full_fb_i_reg && tmp_ram_rd_en) begin
            ram[Q[11:2]] <= din; // Fixed the write operation, accessing 1D array
        end
    end
    
    // Read operation
    always @(posedge clk) begin
        if (tmp_ram_rd_en) begin
            dout <= ram[Q[11:2]]; // Fixed the read operation, accessing 1D array
        end
    end

endmodule