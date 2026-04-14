module top_module(
    input clk,
    input reset,
    input e_tx_access,
    input e_tx_write,
    input [1:0] e_tx_datamode,
    input [3:0] e_tx_ctrlmode,
    input [31:0] e_tx_dstaddr,
    input [31:0] e_tx_srcaddr,
    input [31:0] e_tx_data,
    output reg e_tx_done
);reg [31:0] data_reg;
reg [31:0] dstaddr_reg;
reg [31:0] srcaddr_reg;
reg [3:0] ctrlmode_reg;
reg [1:0] datamode_reg;
reg write_reg;
reg access_reg;
reg done_reg;

always @(posedge clk) begin
    if (reset) begin
        data_reg <= 0;
        dstaddr_reg <= 0;
        srcaddr_reg <= 0;
        ctrlmode_reg <= 0;
        datamode_reg <= 0;
        write_reg <= 0;
        access_reg <= 0;
        done_reg <= 0;
    end else begin
        if (e_tx_access) begin
            data_reg <= e_tx_data;
            dstaddr_reg <= e_tx_dstaddr;
            srcaddr_reg <= e_tx_srcaddr;
            ctrlmode_reg <= e_tx_ctrlmode;
            datamode_reg <= e_tx_datamode;
            write_reg <= e_tx_write;
            access_reg <= 1;
        end
        if (write_reg) begin
            // send data to remote system
            // ...
            done_reg <= 1;
        end
        if (done_reg) begin
            access_reg <= 0;
            done_reg <= 0;
        end
    end
end

assign e_tx_done = done_reg;

endmodule