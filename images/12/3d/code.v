module pcie_receiver (
    input wire clk,
    input wire rst_n,
    input wire [31:0] data_in,
    output reg ready
);
    reg [31:0] data_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_reg <= 32'b0;
            ready <= 1'b0;
        end else begin
            data_reg <= data_in;
            ready <= 1'b1; // Indicate that new data is ready
        end
    end
endmodule