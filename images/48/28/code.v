module top_module(
    input wire clk,
    input wire rst,

    
    input wire [23:0] rx_data_i,
    input wire rx_ack_i,

    
    input wire [31:0] data_i,
    output wire [31:0] data_o,
    input wire [31:0] addr_i,
    input wire we_i);reg [5:0] nextw_ff;
always @(posedge clk) begin
    if (rst)
        nextw_ff <= 0;
    else if (rx_ack_i)
        nextw_ff <= nextw_ff + 1;
end

reg [23:0] ringbuf [63:0];
always @(posedge clk) begin
    if (rx_ack_i)
        ringbuf[nextw_ff] <= rx_data_i;
end

reg [5:0] unread_ff;
reg [5:0] shift_ff;
wire should_shift;
assign should_shift = we_i && addr_i[15:12] == 4'hd && addr_i[7:0] == 8'h00;
always @(posedge clk) begin
    if (rst) begin
        unread_ff <= 0;
        shift_ff <= 0;
    end else if (should_shift && !rx_ack_i) begin
        unread_ff <= unread_ff - 1;
        shift_ff <= shift_ff + 1;
    end else if (!should_shift && rx_ack_i) begin
        unread_ff <= unread_ff + 1;
    end else if (should_shift && rx_ack_i) begin
        shift_ff <= shift_ff + 1;
    end
end


reg [31:0] data_o_ff;
assign data_o = data_o_ff;





wire [5:0] offset_i;
assign offset_i = addr_i[5:0];

always @(posedge clk) begin
    if (addr_i[15:12] == 4'hf)
        data_o_ff <= ringbuf[shift_ff + offset_i];
    else if (addr_i[15:12] == 4'hd && addr_i[7:0] == 8'h00)
        data_o_ff <= unread_ff;
    else
        data_o_ff <= 0;
end

endmodule