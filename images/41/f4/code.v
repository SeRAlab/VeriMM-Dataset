module top_module(clk,data,out_dig,out_seg);input clk;
input [15:0] data;
output [3:0] out_dig;
output [7:0] out_seg;


reg [31:0] clk_cnt;
reg clk_500Hz;

always @ (posedge clk)
    if(clk_cnt == 32'd200_000) begin
        clk_cnt <= 1'b0;
        clk_500Hz <= ~clk_500Hz;
    end
    else
        clk_cnt <= clk_cnt + 1'b1;


reg [3:0] dig_ctrl = 4'b1110;
always @(posedge clk_500Hz)
dig_ctrl <= { dig_ctrl[2:0], dig_ctrl[3] };


reg [4:0] seg_ctrl;
always @ (dig_ctrl)
    case(dig_ctrl)
        4'b1110:    seg_ctrl={1'b0,data[3:0]};
        4'b1101:    seg_ctrl={1'b0,data[7:4]};
        4'b1011:    seg_ctrl={1'b0,data[11:8]};
        4'b0111:    seg_ctrl={1'b0,data[15:12]};
        default:      seg_ctrl=5'h1f;
    endcase


reg [7:0] seg_reg;

always @( seg_ctrl )
    case( seg_ctrl )
        5'h00:  seg_reg = 8'b1100_0000;
        5'h01:  seg_reg = 8'b1111_1001;
        5'h02:  seg_reg = 8'b1010_0100;
        5'h03:  seg_reg = 8'b1011_0000;
        5'h04:  seg_reg = 8'b1001_1001;
        5'h05:  seg_reg = 8'b1001_0010;
        5'h06:  seg_reg = 8'b1000_0010;
        5'h07:  seg_reg = 8'b1111_1000;
        5'h08:  seg_reg = 8'b1000_0000;
        5'h09:  seg_reg = 8'b1001_0000;
        5'h0a:  seg_reg = 8'b1000_1000;
        5'h0b:  seg_reg = 8'b1000_0011;
        5'h0c:  seg_reg = 8'b1100_0110;
        5'h0d:  seg_reg = 8'b1010_0001;
        5'h0e:  seg_reg = 8'b1000_0110;
        5'h0f:  seg_reg = 8'b1000_1110;
        5'h10:  seg_reg = 8'b1111_1111;
        5'h11:  seg_reg = 8'b1100_0111;
        5'h12:  seg_reg = 8'b1010_1111;
        5'h13:  seg_reg = 8'b1010_0001;
        5'h14:  seg_reg = 8'b1010_0011;
        5'h15:  seg_reg = 8'b1010_1011;
        5'h16:  seg_reg = 8'b1000_0110;

        default:seg_reg = 8'b1111_1111;
    endcase

assign out_dig = dig_ctrl;
assign out_seg = seg_reg;

endmodule