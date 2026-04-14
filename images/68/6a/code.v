module top_module(
    input datainlo,
    input datainhi,
    input clk,
    input muxsel,
    input ena,
    input areset,
    input sreset,
    output reg dataout
);reg [1:0] dff;
reg [1:0] dff_next;
reg [1:0] dff_sync;
reg [1:0] dff_sync_next;
reg [1:0] dff_half;
reg [1:0] dff_half_next;
reg [1:0] dff_half_sync;
reg [1:0] dff_half_sync_next;
reg muxsel_next;

always @(posedge clk) begin
    if (areset) begin
        dff <= 2'b0;
        dff_sync <= 2'b0;
        dff_half <= 2'b0;
        dff_half_sync <= 2'b0;
    end else if (sreset) begin
        dff_sync <= 2'b0;
        dff_half_sync <= 2'b0;
    end else begin
        dff <= dff_next;
        dff_sync <= dff_sync_next;
        dff_half <= dff_half_next;
        dff_half_sync <= dff_half_sync_next;
    end
end

always @(posedge clk) begin
    if (muxsel_next) begin
        dff_next[1] <= datainhi;
        dff_next[0] <= dff_half_sync[1];
    end else begin
        dff_next[1] <= dff_half_sync[1];
        dff_next[0] <= datainlo;
    end
end

always @(posedge clk) begin
    if (ena) begin
        dff_sync_next <= dff_next;
        dff_half_sync_next <= dff_half_next;
    end else begin
        dff_sync_next <= dff_sync;
        dff_half_sync_next <= dff_half_sync;
    end
end

always @(posedge clk) begin
    dff_half <= dff;
    dff_half_next <= dff_next;
end

always @(posedge clk) begin
    muxsel_next <= muxsel;
end

assign dataout = muxsel_next ? dff_sync[1] : dff_sync[0];

endmodule