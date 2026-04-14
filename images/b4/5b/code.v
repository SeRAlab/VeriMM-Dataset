module top_module(
    input clk,
    input rst_n,
    input reset_interface,
    input usr_arb_rx_rd_valid,
    input usr_arb_rx_rd_tag,
    input usr_arb_rx_data,
    input usr_pipe_rx_rd_valid,
    input usr_pipe_rx_rd_tag,
    input usr_pipe_rx_data,
    output reg [31:0] rx_data_reg,
    output reg [31:0] rx_rd_tag_reg,
    output reg rx_rd_valid_reg
);// data
always @(posedge clk) begin
    if(usr_arb_rx_rd_valid) begin
        rx_data_reg <= usr_arb_rx_data;
    end
    else begin
        rx_data_reg <= usr_pipe_rx_data;
    end
end

// valid
always @(posedge clk) begin
    if (~rst_n | reset_interface) begin
        rx_rd_tag_reg <= 0;
        rx_rd_valid_reg <= 0;
    end
    else begin
        if(usr_arb_rx_rd_valid) begin
            rx_rd_tag_reg <= usr_arb_rx_rd_tag;
            rx_rd_valid_reg <= 1'b1;
        end
        else begin
            rx_rd_tag_reg <= usr_pipe_rx_rd_tag;
            rx_rd_valid_reg <= usr_pipe_rx_rd_valid;
        end
    end
end

endmodule