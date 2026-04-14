module top_module(
    input clk, rst, enable, count_dir, dual_count,
    output reg [7:0] count_out
);always @(posedge clk or negedge rst) begin
        if (~rst) begin
            count_out <= 8'h00; // reset the counter to 0
        end else if (enable) begin
            if (count_dir == 1'b0) begin // up-counting
                if (dual_count) begin
                    count_out <= count_out + 2;
                end else begin
                    count_out <= count_out + 1;
                end
            end else begin // down-counting
                if (dual_count) begin
                    count_out <= count_out - 2;
                end else begin
                    count_out <= count_out - 1;
                end
            end
            if (count_out == 8'h00 && count_dir == 1'b1) begin // wrap around to maximum value when counting down
                count_out <= 8'hFF;
            end else if (count_out == 8'hFF && count_dir == 1'b0) begin // wrap around to 0 when counting up
                count_out <= 8'h00;
            end
        end
    end

endmodule