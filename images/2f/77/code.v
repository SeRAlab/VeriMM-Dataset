module pcie_endpoint_controller (
    input wire clk,
    input wire reset,
    input wire command,
    output reg ack
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ack <= 0;
        end else if (command) begin
            ack <= 1; // Acknowledge the command
        end else begin
            ack <= 0; // De-assert acknowledgment if no command
        end
    end
endmodule