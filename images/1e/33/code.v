module pcie_receiver (
    input wire clk,
    input wire [63:0] data_in,
    input wire [3:0] data_valid,
    output reg [63:0] received_data
);
    always @(posedge clk) begin
        if (data_valid != 4'b0000) begin
            received_data <= data_in;
        end
    end
endmodule