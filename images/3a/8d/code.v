module data_forwarding_unit (
    input [4:0] src1,
    input [4:0] src2,
    input [4:0] dest,
    input forward_sel,
    output reg [4:0] forward_data
);
    always @(*) begin
        if (forward_sel) begin
            forward_data = dest; // Forward the data from dest register
        end else begin
            forward_data = src1; // Otherwise, use data from src1
        end
    end
endmodule