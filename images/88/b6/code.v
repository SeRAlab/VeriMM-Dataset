module top_module(
    input [2:0] sel, 
    input [3:0] data0,
    input [3:0] data1,
    input [3:0] data2,
    input [3:0] data3,
    input [3:0] data4,
    input [3:0] data5,
    input [1:0] shift_amount,
    output reg [3:0] out
);reg [1:0] shifted_data0;
reg [1:0] shifted_data1;
reg [1:0] shifted_data2;
reg [1:0] shifted_data3;
reg [1:0] shifted_data4;
reg [1:0] shifted_data5;

always @(*) begin
    case (shift_amount)
        2'b00: begin
            shifted_data0 = data0[1:0];
            shifted_data1 = data1[1:0];
            shifted_data2 = data2[1:0];
            shifted_data3 = data3[1:0];
            shifted_data4 = data4[1:0];
            shifted_data5 = data5[1:0];
        end
        2'b01: begin
            shifted_data0 = {data0[0], data0[3]};
            shifted_data1 = {data1[0], data1[3]};
            shifted_data2 = {data2[0], data2[3]};
            shifted_data3 = {data3[0], data3[3]};
            shifted_data4 = {data4[0], data4[3]};
            shifted_data5 = {data5[0], data5[3]};
        end
        2'b10: begin
            shifted_data0 = {data0[2:1], 2'b00};
            shifted_data1 = {data1[2:1], 2'b00};
            shifted_data2 = {data2[2:1], 2'b00};
            shifted_data3 = {data3[2:1], 2'b00};
            shifted_data4 = {data4[2:1], 2'b00};
            shifted_data5 = {data5[2:1], 2'b00};
        end
        2'b11: begin
            shifted_data0 = {2'b00, data0[2:1]};
            shifted_data1 = {2'b00, data1[2:1]};
            shifted_data2 = {2'b00, data2[2:1]};
            shifted_data3 = {2'b00, data3[2:1]};
            shifted_data4 = {2'b00, data4[2:1]};
            shifted_data5 = {2'b00, data5[2:1]};
        end
    endcase
end

always @(*) begin
    case (sel)
        3'b000: out = shifted_data0;
        3'b001: out = shifted_data1;
        3'b010: out = shifted_data2;
        3'b011: out = shifted_data3;
        3'b100: out = shifted_data4;
        3'b101: out = shifted_data5;
        default: out = 4'b0000;
    endcase
end

endmodule