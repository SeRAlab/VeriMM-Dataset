module pcie_tlp_processor (
    input wire [7:0] tlp_in,
    input wire valid,
    output reg [3:0] tlp_out
);
    always @(posedge valid or negedge valid) begin
        if (valid) begin
            tlp_out <= tlp_in[7:4];
        end
    end
endmodule