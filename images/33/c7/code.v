module pcie_receiver (
    input wire clk,
    input wire reset,
    input wire [31:0] data_in,
    input wire [1:0] cmd_in,
    output reg [31:0] data_out,
    output reg valid_out
);
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            data_out <= 32'b0;
            valid_out <= 1'b0;
        end else begin
            if (cmd_in == 2'b01) begin
                data_out <= data_in;
                valid_out <= 1'b1;
            end else begin
                valid_out <= 1'b0;
            end
        end
    end
endmodule