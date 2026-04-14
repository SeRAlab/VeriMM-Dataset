module top_module(
    input [3:0] A,
    input [3:0] B,
    input [3:0] C,
    input [3:0] D,
    output reg Y0,
    output reg Y1
);always @(*) begin
    case ({A,B})
        2'b11: Y0 = 1'b1;
        2'b10: Y0 = 1'b1;
        2'b01: Y0 = 1'b1;
        2'b00: Y0 = 1'b0;
    endcase
    
    case ({C,D})
        2'b11: Y1 = 1'b1;
        2'b10: Y1 = 1'b1;
        2'b01: Y1 = 1'b1;
        2'b00: Y1 = 1'b0;
    endcase
end

endmodule