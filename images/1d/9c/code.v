module pcie_controller (
    input wire clk,
    input wire new_request,
    output reg response
);

    // State to indicate if a request is being processed
    reg processing;

    always @(posedge clk) begin
        if (new_request) begin
            processing <= 1'b1;
            response <= 1'b0; // No response initially
        end else if (processing) begin
            response <= 1'b1; // Send response after one clock cycle
            processing <= 1'b0; // Reset processing state
        end else begin
            response <= 1'b0; // No response
        end
    end

endmodule