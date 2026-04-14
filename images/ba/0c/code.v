module top_module(
    input clk,
    input rstn,
    input [5:0] cnt,
    input [6:0] blockcnt,
    input [5:0] bestmode,
    input [5:0] bestmode16,
    input [5:0] bestmode32,
    input finish,
    output reg md_we,
    output reg [5:0] md_wdata,
    output reg [6:0] md_waddr
);always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            md_waddr <= 7'd0;
        end
        else if (md_we) begin
            md_waddr <= md_waddr + 1'b1;
        end
        else if (finish) begin
            md_waddr <= 7'd0;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            md_we <= 1'b0;
        end
        else if (((blockcnt > 7'd1) && (cnt == 6'd11))
                 || ((blockcnt[1:0] == 2'b01) && (cnt == 6'd12) && (blockcnt != 7'd1))
                 || ((blockcnt[3:0] == 4'b0001) && (cnt == 6'd13) && (blockcnt != 7'd1))) begin
            md_we <= 1'b1;
        end
        else begin
            md_we <= 1'b0;
        end
    end

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            md_wdata <= 'd0;
        end
        else if (cnt == 'd11) begin
            md_wdata <= bestmode;
        end
        else if (cnt == 'd12) begin
            md_wdata <= bestmode16;
        end
        else if (cnt == 'd13) begin
            md_wdata <= bestmode32;
        end
    end

endmodule