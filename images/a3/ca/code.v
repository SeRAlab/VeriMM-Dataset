module top_module(clk, rst, ctrl, out);input clk, rst, ctrl;
    output reg [3:0] out;

    always @(posedge clk) begin
        if (rst) begin
            out <= 4'b0000;
        end else begin
            if (ctrl) begin
                if (out == 4'b1111) begin
                    out <= 4'b0000;
                end else begin
                    out <= out + 1;
                end
            end else begin
                if (out == 4'b0000) begin
                    out <= 4'b1111;
                end else begin
                    out <= out - 1;
                end
            end
        end
    end

endmodule