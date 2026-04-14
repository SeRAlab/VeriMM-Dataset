module decoder2to4 (
    input wire A1,
    input wire A0,
    output reg Y0,
    output reg Y1,
    output reg Y2,
    output reg Y3
);
    
    always @(*) begin
        case ({A1, A0})
            2'b00: {Y0, Y1, Y2, Y3} = 4'b0001;
            2'b01: {Y0, Y1, Y2, Y3} = 4'b0010;
            2'b10: {Y0, Y1, Y2, Y3} = 4'b0100;
            2'b11: {Y0, Y1, Y2, Y3} = 4'b1000;
            default: {Y0, Y1, Y2, Y3} = 4'b0000; // default case
        endcase
    end
endmodule