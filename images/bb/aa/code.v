module top_module(
    input clk, rst, we_i, tx_pop_i,
    input [31:0] data_i, addr_i,
    output reg [31:0] data_o,
    output reg tx_ack_o,
    output reg [5:0] queued_ff
);parameter Q_SIZE = 64;
reg [31:0] queue [0:Q_SIZE-1];
reg [5:0] head = 0;
reg [5:0] tail = 0;

always @(posedge clk) begin
    if (rst) begin
        head <= 0;
        tail <= 0;
        tx_ack_o <= 0;
        queued_ff <= 0;
    end else if (we_i) begin
        queue[addr_i] <= data_i;
        queued_ff <= queued_ff + 1;
    end else if (tx_pop_i) begin
        data_o <= queue[tail];
        tx_ack_o <= 1;
        queued_ff <= queued_ff - 1;
        tail <= (tail == Q_SIZE-1) ? 0 : tail + 1;
    end else begin
        tx_ack_o <= 0;
    end
end

endmodule