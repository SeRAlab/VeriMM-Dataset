module top_module(
    d,
    clk,
    en,
    dir,
    rst,
    out
);input   d;
input clk;
input en;
input dir;
input rst;
output reg [31:0] out;

always @(posedge clk) begin
    if(!rst) begin
        out <= 0;
    end
    if(en) begin
        case(dir)
            0: begin
                out <= {out[29:0], d};
            end
            1: begin
                out <= {d, out[30:1]};
            end
        endcase
    end
    else begin
        out <= out;
	 end
 end
 
 endmodule