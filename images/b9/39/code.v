module top_module(
    input clk,
    input rst_n,
    input enable,
    output reg VPWR,
    output reg VGND
);always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        VPWR <= 0;
        VGND <= 0;
    end else if (enable) begin
        VPWR <= 1;
        VGND <= 0;
    end else begin
        VPWR <= 0;
        VGND <= 0;
    end
end

endmodule