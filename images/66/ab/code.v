module top_module(
    input clk,
    input rst,
    input [7:0] current_test,
    input [63:0] xgmii_txd,
    input [7:0] xgmii_txc,
    output reg [63:0] encoded_tx_data,
    output reg [1:0] encoded_tx_hdr
);// Parameters
parameter DATA_WIDTH = 64;
parameter CTRL_WIDTH = (DATA_WIDTH/8);
parameter HDR_WIDTH = 2;
parameter DATA_MSB = DATA_WIDTH - 1;

// Internal signals
reg [DATA_MSB:0] data_reg = 0;
reg [1:0] header_reg = 2'b00;

// Encoding logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        data_reg <= 0;
        header_reg <= 2'b00;
    end else begin
        data_reg <= {xgmii_txd[DATA_MSB-7:0], xgmii_txc};
        header_reg <= {xgmii_txd[DATA_MSB-1], xgmii_txd[DATA_MSB]};
    end
end

// Output assignments
assign encoded_tx_data = data_reg;
assign encoded_tx_hdr = header_reg;

endmodule