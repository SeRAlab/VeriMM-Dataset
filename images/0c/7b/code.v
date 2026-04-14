module ethernet_mac_controller (
    input wire clk,
    input wire rst,
    input wire [7:0] data_in,
    input wire valid_in,
    output reg tx_enable,
    output reg [7:0] data_out
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_enable <= 0;
            data_out <= 8'b0;
        end else if (valid_in) begin
            tx_enable <= 1;
            data_out <= data_in;
        end else begin
            tx_enable <= 0;
        end
    end
endmodule