module top_module(
    input sys_clk,
    input sys_rst,

    output busy,

    input pipe_stb_i,
    output pipe_ack_o,
    input signed [11:0] dx,
    input signed [11:0] dy,
    input signed [17:0] tx,
    input signed [17:0] ty,

    input [10:0] tex_hres,
    input [10:0] tex_vres,
    input [10:0] dst_hres,
    input [10:0] dst_vres,

    output reg pipe_stb_o,
    input pipe_ack_i,
    output reg [10:0] dx_c,
    output reg [10:0] dy_c,
    output reg [16:0] tx_c,
    output reg [16:0] ty_c
);always @(posedge sys_clk) begin
    if(sys_rst)
        pipe_stb_o <= 1'b0;
    else begin
        if(pipe_ack_i)
            pipe_stb_o <= 1'b0;
        if(pipe_stb_i & pipe_ack_o) begin
            if((dx[11] == 1) || (dy[11] == 1)) begin
                pipe_stb_o <= 1'b0;
            end else if((dx[10:0] >= dst_hres) || (dy[10:0] >= dst_vres)) begin
                pipe_stb_o <= 1'b0;
            end else begin
                pipe_stb_o <= 1'b1;
                dx_c <= dx[10:0];
                dy_c <= dy[10:0];
                if(tx[17] == 1) begin
                    tx_c <= 17'd0;
                end else if(tx[16:0] > {tex_hres - 11'd1, 6'd0}) begin
                    tx_c <= {tex_hres - 11'd1, 6'd0};
                end else begin
                    tx_c <= tx[16:0];
                end
                if(ty[17] == 1) begin
                    ty_c <= 17'd0;
                end else if(ty[16:0] > {tex_vres - 11'd1, 6'd0}) begin
                    ty_c <= {tex_vres - 11'd1, 6'd0};
                end else begin
                    ty_c <= ty[16:0];
                end
            end
        end
    end
end

assign pipe_ack_o = ~pipe_stb_o | pipe_ack_i;

assign busy = pipe_stb_o;

endmodule