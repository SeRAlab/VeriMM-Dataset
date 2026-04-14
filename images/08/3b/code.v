module pcie_interface (
    input wire [63:0] data_in,
    input wire wr_en,
    input wire clk,
    output reg [79:0] data_out
);
    always @(posedge clk) begin
        if (wr_en) begin
            data_out <= {8'h5A, data_in, 8'hA5}; // Frame data with SOF and EOF
        end
    end
endmodule