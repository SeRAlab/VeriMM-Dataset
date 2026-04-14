module pcie_request_handler (
    input wire clk,
    input wire rst,
    input wire req,
    output reg ack
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ack <= 0;
        end else if (req) begin
            ack <= 1;
        end else begin
            ack <= 0;
        end
    end
endmodule