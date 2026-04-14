module top_module(clk, rst, j, k, q, qbar);input clk, rst, j, k;
    output q, qbar;
    reg q, qbar;
    always @(posedge clk or posedge rst)
    begin
        if (rst)
        begin
            q <= 1'b0;
            qbar <= 1'b1;
        end
        else
        begin
            case ({j, k})
                2'b00: begin q <= q; qbar <= qbar; end
                2'b01: begin q <= 1'b0; qbar <= 1'b1; end
                2'b10: begin q <= 1'b1; qbar <= 1'b0; end
                2'b11: begin q <= ~q; qbar <= ~qbar; end
            endcase
        end
    end
endmodule