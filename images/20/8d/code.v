module pcie_endpoint_controller (
    input wire clk,
    input wire reset,
    input wire valid,
    input wire [31:0] data_in,
    output reg [31:0] data_out,
    output reg packet_received
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 32'b0;
            packet_received <= 1'b0;
        end else if (valid) begin
            data_out <= data_in;
            packet_received <= 1'b1;
        end else begin
            packet_received <= 1'b0;
        end
    end
endmodule