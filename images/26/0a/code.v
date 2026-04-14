module pcie_request_handler (
    input wire clk,
    input wire req,
    input wire ack,
    output reg busy
);

    always @(posedge clk) begin
        if (req) begin
            busy <= 1'b1; // Set busy when a request arrives
        end
        if (ack) begin
            busy <= 1'b0; // Clear busy when the request is acknowledged
        end
    end

endmodule