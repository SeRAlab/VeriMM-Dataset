module pcie_endpoint_controller (
    input wire clk,
    input wire rst,
    input wire [31:0] addr_in,
    input wire [31:0] data_in,
    input wire valid,
    output reg [31:0] addr_out,
    output reg [31:0] data_out,
    output reg ready
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        addr_out <= 32'b0;
        data_out <= 32'b0;
        ready <= 1'b1;
    end else if (valid && ready) begin
        addr_out <= addr_in;
        data_out <= data_in;
        ready <= 1'b0; // Not ready until transaction completed
    end else begin
        ready <= 1'b1; // Ready if not processing
    end
end

endmodule