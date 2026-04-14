module nvme_controller (
    input wire clk,
    input wire reset,
    input wire cmd_valid,
    input wire [7:0] cmd,
    input wire [31:0] addr,
    input wire process,
    output reg [7:0] out_cmd,
    output reg [31:0] out_addr,
    output reg ready
);
    reg [7:0] cmd_reg;
    reg [31:0] addr_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cmd_reg <= 8'b0;
            addr_reg <= 32'b0;
            ready <= 1'b0;
        end else if (cmd_valid) begin
            cmd_reg <= cmd;
            addr_reg <= addr;
            ready <= 1'b0; // Reset ready until process signal is asserted
        end else if (process) begin
            out_cmd <= cmd_reg;
            out_addr <= addr_reg;
            ready <= 1'b1; // Set ready high when data is output
        end
    end
endmodule