module ethernet_mac_tx (
    input wire clk,
    input wire rst,
    input wire tx_en,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output reg tx_complete
);
    reg [7:0] data_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_reg <= 8'd0;
            data_out <= 8'd0;
            tx_complete <= 0;
        end else if (tx_en) begin
            data_reg <= data_in;
            data_out <= data_reg;
            tx_complete <= 1;
        end else begin
            tx_complete <= 0;
        end
    end
endmodule