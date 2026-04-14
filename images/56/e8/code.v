module top_module(num, dig, code);input [2:0]			num;		
	input [39:0]		dig;
	output reg [4:0]	code;		

	always @(num) begin
        case(num)
            3'd0: code = dig[4:0];
            3'd1: code = dig[9:5];
            3'd2: code = dig[14:10];
            3'd3: code = dig[19:15];
            3'd4: code = dig[24:20];
            3'd5: code = dig[29:25];
            3'd6: code = dig[34:30];
            3'd7: code = dig[39:35];
            default: code = 5'b00000;
        endcase
    end

endmodule