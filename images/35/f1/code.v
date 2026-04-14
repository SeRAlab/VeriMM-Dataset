module pcie_endpoint(
    input wire clk,
    input wire req,
    output reg resp
);
    reg state; // 0: idle, 1: processing

    always @(posedge clk) begin
        if (req && !state) begin
            state <= 1; // Transition to processing state
            resp <= 0; // Response is low while processing
        end else if (state) begin
            resp <= 1; // Assert response after one cycle
            state <= 0; // Transition back to idle state
        end else begin
            resp <= 0; // Hold response low in idle state
        end
    end
endmodule