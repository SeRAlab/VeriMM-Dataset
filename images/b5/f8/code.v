/***************************************FIFO*****************************************/
module sync_fifo#(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input                   clk,
    input                   rstn,
    input                   winc,
    input                   rinc,
    input   [WIDTH-1:0]     wdata,

    output                  wfull,
    output                  rempty,
    output  [WIDTH-1:0]     rdata
);

parameter ADDR_WIDTH = $clog2(DEPTH);

reg [WIDTH-1:0] fifo_mem [0:DEPTH-1];
reg [ADDR_WIDTH-1:0] wptr, rptr, wptr_next, rptr_next;
reg full, empty;

assign wfull = full;
assign rempty = empty;
assign rdata = fifo_mem[rptr];

always @(posedge clk or negedge rstn) begin
    if(~rstn) begin
        wptr <= 0;
        rptr <= 0;
        full <= 0;
        empty <= 1;
    end else begin
        if (winc && !full) begin
            fifo_mem[wptr] <= wdata;
            wptr <= wptr_next;
        end
        if (rinc && !empty) begin
            rptr <= rptr_next;
        end
        if (wptr_next == rptr && winc && !rinc) begin
            full <= 1;
        end else if (winc && rinc) begin
            full <= full;
        end else begin
            full <= 0;
        end
        if (wptr == rptr_next && rinc && !winc) begin
            empty <= 1;
        end else if (winc && rinc) begin
            empty <= empty;
        end else begin
            empty <= 0;
        end
    end
end

assign wptr_next = (wptr + 1) % DEPTH;
assign rptr_next = (rptr + 1) % DEPTH;

endmodule