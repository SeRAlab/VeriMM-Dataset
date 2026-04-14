module pcie_endpoint_controller (
    input wire clk,
    input wire request,
    output reg acknowledge
);
    always @(posedge clk) begin
        if (request) begin
            acknowledge <= 1'b1; // Set acknowledge high on request
        end else begin
            acknowledge <= 1'b0; // Reset acknowledge low otherwise
        end
    end
endmodule