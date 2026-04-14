module pcie_controller(
    input wire clk,
    input wire rst_n,
    input wire wr_en,
    input wire rd_en,
    input wire [15:0] addr_in,
    input wire [31:0] data_in,
    output reg [31:0] data_out,
    output reg [15:0] addr_out
);
    
    reg [31:0] data_reg;
    reg [15:0] addr_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            addr_reg <= 16'd0;
            data_reg <= 32'd0;
        end else begin
            if (wr_en) begin
                addr_reg <= addr_in;
                data_reg <= data_in;
            end
            if (rd_en) begin
                addr_out <= addr_reg;
                data_out <= data_reg;
            end
        end
    end
endmodule