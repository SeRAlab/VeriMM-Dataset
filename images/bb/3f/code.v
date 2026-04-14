module top_module(
    input [3:0] DATA_IN,
    output reg [7:0] DATA_OUT
    );always @(*) begin
        case(DATA_IN)
            4'd0: DATA_OUT=8'b00000001;
            4'd1: DATA_OUT=8'b00000010;
            4'd2: DATA_OUT=8'b00000100;
            4'd3: DATA_OUT=8'b00001000;
            4'd4: DATA_OUT=8'b00010000;
            4'd5: DATA_OUT=8'b00100000;
            4'd6: DATA_OUT=8'b01000000;
            4'd7: DATA_OUT=8'b10000000;
            4'd8: DATA_OUT=8'b10000001;
            4'd9: DATA_OUT=8'b10000010;
            default: DATA_OUT=8'b00000000;
        endcase
    end        
endmodule