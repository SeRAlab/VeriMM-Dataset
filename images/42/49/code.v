module top_module(
    input [3:0] NUM,
    output reg [7:0] CATODOS

    );always @(*) begin
        case(NUM)
                        4'd0: CATODOS=8'b00000011;
                        4'd1: CATODOS=8'b10011111;
                        4'd2: CATODOS=8'b00100101;
                        4'd3: CATODOS=8'b00001101;
                        4'd4: CATODOS=8'b10011001;
                        4'd5: CATODOS=8'b01001001;
                        4'd6: CATODOS=8'b01000001;
                        4'd7: CATODOS=8'b00011111;
                        4'd8: CATODOS=8'b00000001;
                        4'd9: CATODOS=8'b00011001;
                        4'd10: CATODOS=8'b00010001;
                        4'd11: CATODOS=8'b11000001;
                        4'd12: CATODOS=8'b01100011;
                        4'd13: CATODOS=8'b10000101;
                        4'd14: CATODOS=8'b01100001;
                        4'd15: CATODOS=8'b01110001;
                        default CATODOS=8'b11111101;
        endcase
    end        
endmodule