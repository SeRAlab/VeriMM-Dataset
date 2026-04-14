module pcie_endpoint_controller (
    input wire clk,
    input wire reset,
    input wire req,
    output reg resp
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            resp <= 0;
        end else if (req) begin
            resp <= 1;
        end else begin
            resp <= 0;
        end
    end
endmodule