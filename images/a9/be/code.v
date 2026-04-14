module top_module(
    input clk,
    input rst,
    input en,
    input [15:0] cnt_max,
    input cnt_dir,
    output reg [15:0] cnt_out
);always @(posedge clk) begin
        if(rst) begin
            cnt_out <= 0;
        end else if(en) begin
            if(cnt_dir == 0) begin
                if(cnt_out == cnt_max) begin
                    cnt_out <= 0;
                end else begin
                    cnt_out <= cnt_out + 1;
                end
            end else begin
                if(cnt_out == 0) begin
                    cnt_out <= cnt_max;
                end else begin
                    cnt_out <= cnt_out - 1;
                end
            end
        end
    end

endmodule