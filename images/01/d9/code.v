module pcie_endpoint_controller (
    input wire clk,
    input wire rst,
    input wire req,
    input wire [31:0] data_in,
    output reg ack,
    output reg [31:0] data_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ack <= 0;
            data_out <= 32'b0;
        end else begin
            if (req) begin
                ack <= 1;
                data_out <= data_in;
            end else begin
                ack <= 0;
            end
        end
    end
endmodule