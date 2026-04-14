module top_module( 
    input [2:0] sel, 
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    output reg [3:0] out
);reg [1:0] and_result;

always @* begin
    case (sel)
        3'b000: out = data0;
        3'b001: out = data1;
        3'b010: out = data2;
        3'b011: out = data3;
        3'b100: out = data4;
        3'b101: out = data5;
        3'b110, 3'b111: begin
            and_result = data0[1:0] & data1[1:0] & data2[1:0] & data3[1:0] & data4[1:0] & data5[1:0];
            out = {and_result, and_result};
        end
    endcase
end

endmodule