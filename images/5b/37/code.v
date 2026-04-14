module top_module(
    input wire clk,
    input wire rst,

    
    output wire [23:0] tx_data_o,
    input wire tx_pop_i,
    output wire tx_ack_o,

    
    input wire [31:0] data_i,
    output wire [31:0] data_o,
    input wire [31:0] addr_i,
    input wire we_i);reg [5:0] queued_ff;
reg [5:0] lastr_ff;
reg [5:0] nextw_ff;

reg [23:0] ringbuf [63:0];
assign tx_data_o = ringbuf[lastr_ff];

wire should_queue;
assign should_queue = we_i && addr_i[15:12] == 4'hd && addr_i[7:0] == 8'h01;
always @(posedge clk) begin
    if (rst) begin
        queued_ff <= 0;
        lastr_ff <= 6'h3f;
        nextw_ff <= 0;
    end else if (should_queue && !tx_pop_i) begin
        ringbuf[nextw_ff] <= data_i;
        queued_ff <= queued_ff + 1;
        nextw_ff <= nextw_ff + 1;
    end else if (!should_queue && tx_pop_i) begin
        if (queued_ff > 0) begin
            queued_ff <= queued_ff - 1;
            lastr_ff <= lastr_ff + 1;
        end
    end else if (should_queue && tx_pop_i) begin
        ringbuf[nextw_ff] <= data_i;
        if (queued_ff > 0) begin
            lastr_ff <= lastr_ff + 1;
        end else begin
            queued_ff <= queued_ff + 1;
        end
        nextw_ff <= nextw_ff + 1;
    end
end

reg tx_ack_ff;
always @(posedge clk)
    tx_ack_ff <= tx_pop_i;
assign tx_ack_o = tx_ack_ff;


reg [31:0] data_o_ff;
assign data_o = data_o_ff;





wire [5:0] offset_i;
assign offset_i = addr_i[5:0];

always @(posedge clk) begin
    if (addr_i[15:12] == 4'he)
        data_o_ff <= ringbuf[nextw_ff - 1 - offset_i];
    else if (addr_i[15:12] == 4'hd && addr_i[7:0] == 8'h01)
        data_o_ff <= queued_ff;
    else
        data_o_ff <= 0;
end

endmodule