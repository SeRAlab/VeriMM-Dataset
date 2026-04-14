module pcie_endpoint_controller(
    input wire clk,
    input wire rst_n,
    input wire req,
    output reg rsp
);

    reg req_d;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rsp <= 1'b0;
            req_d <= 1'b0;
        end else begin
            req_d <= req;
            rsp <= req_d;
        end
    end
endmodule