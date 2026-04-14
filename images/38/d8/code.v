module NVMe_Controller (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire write,
    input wire read,
    input wire [31:0] data_in,
    output reg [31:0] data_out
);
    reg [31:0] data_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_reg <= 32'b0;
            data_out <= 32'b0;
        end else if (enable) begin
            if (write) begin
                data_reg <= data_in;
            end
            if (read) begin
                data_out <= data_reg;
            end
        end
    end
endmodule