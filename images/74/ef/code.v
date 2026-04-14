module top_module(
    input wire [3:0] bcd,
    output reg [7:0] ssd
    );always @(*) begin
        case(bcd)
            4'd0 : ssd = 8'b0000_0011;
            4'd1 : ssd = 8'b1001_1111;
            4'd2 : ssd = 8'b0010_0101;
            4'd3 : ssd = 8'b0000_1101;
            4'd4 : ssd = 8'b1001_1001;
            4'd5 : ssd = 8'b0100_1001;
            4'd6 : ssd = 8'b0100_0001;
            4'd7 : ssd = 8'b0001_1111;
            4'd8 : ssd = 8'b0000_0001;
            4'd9 : ssd = 8'b0000_1001;
            4'd10 : ssd = 8'b1111_1110; 

            4'd11 : ssd = 8'b0111_0001; 
            4'd12 : ssd = 8'b0001_0001; 
            4'd13 : ssd = 8'b1111_0011; 
            4'd14 : ssd = 8'b1110_0011; 

            default : ssd = 8'b1111_1111;
        endcase
    end
           
endmodule