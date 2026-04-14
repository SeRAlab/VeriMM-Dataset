module top_module(
    input [5:0] num,
    output reg [2:0] lognum);always @(*) begin
        case (num)
            6'b000000: lognum = 3'd0;
            6'b000001: lognum = 3'd1;
            6'b000011: lognum = 3'd2;
            6'b000111: lognum = 3'd3;
            6'b001111: lognum = 3'd4;
            6'b011111: lognum = 3'd5;
            6'b111111: lognum = 3'd6;
            default: lognum = 3'd0;
        endcase
    end
    
endmodule