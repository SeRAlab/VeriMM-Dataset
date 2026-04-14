module pcie_controller (
    input wire clk,
    input wire req,
    output reg ack
);
    always @(posedge clk) begin
        if (req) begin
            ack <= 1'b1; // Acknowledge the request
        end else begin
            ack <= 1'b0; // No acknowledgment if no request
        end
    end
endmodule