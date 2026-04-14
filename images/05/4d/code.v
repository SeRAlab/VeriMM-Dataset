module pcie_packet_handler (
    input wire clk,
    input wire rst,
    input wire txn_valid,
    input wire [1:0] txn_type,
    input wire [31:0] txn_addr,
    output reg txn_ready
);
    reg [1:0] stored_txn_type;
    reg [31:0] stored_txn_addr;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            stored_txn_type <= 2'b00;
            stored_txn_addr <= 32'b0;
            txn_ready <= 0;
        end else if (txn_valid) begin
            stored_txn_type <= txn_type;
            stored_txn_addr <= txn_addr;
            txn_ready <= 1;
        end
    end
endmodule