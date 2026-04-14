module pcie_endpoint_controller (
    input wire clk,
    input wire reset,
    input wire read_req,
    input wire [3:0] addr,
    output reg [31:0] data_out
);

    reg [31:0] config_reg [0:15]; // 16 registers, each 32 bits wide

    // Initialize the configuration registers
    initial begin
        config_reg[0] = 32'hDEADBEEF;
        config_reg[1] = 32'hCAFEBABE;
        config_reg[2] = 32'hFEEDFACE;
        config_reg[3] = 32'hBEEFCAFE;
        config_reg[4] = 32'hBA5B00B5;
        config_reg[5] = 32'hBAADC0DE;
        config_reg[6] = 32'h1BADF00D;
        config_reg[7] = 32'h5BADF00D;
        config_reg[8] = 32'h0BADF00D;
        config_reg[9] = 32'hC0FFEE00;
        config_reg[10] = 32'hB16B00B5;
        config_reg[11] = 32'hDECADE01;
        config_reg[12] = 32'hBADCAFE0;
        config_reg[13] = 32'hBEEFBABE;
        config_reg[14] = 32'hB00B0001;
        config_reg[15] = 32'hFACEFEED;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 32'b0; // Reset output
        end else if (read_req) begin
            data_out <= config_reg[addr]; // Output the requested register
        end
    end
endmodule