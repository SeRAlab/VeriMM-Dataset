module pcie_endpoint_controller (
    input wire clk,
    input wire rst_n,
    input wire request,
    output reg grant
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            grant <= 0;
        end else if (request) begin
            grant <= 1;
        end else begin
            grant <= 0;
        end
    end
endmodule